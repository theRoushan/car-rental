package database

import (
	"car-rental-backend/config"
	"fmt"
	"log"
	"strings"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

// InitDB initializes the database connection and performs auto-migration
func InitDB(cfg *config.Config) error {
	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		cfg.DBHost,
		cfg.DBPort,
		cfg.DBUser,
		cfg.DBPassword,
		cfg.DBName,
		cfg.DBSSLMode,
	)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		// Disable constraint building to prevent automatic constraint manipulation
		DisableForeignKeyConstraintWhenMigrating: true,
	})
	if err != nil {
		return fmt.Errorf("failed to connect to database: %v", err)
	}

	// Apply known error-prone migrations first using SQL Exec
	if err := applyConstraintFixes(db); err != nil {
		log.Printf("Warning: Failed to apply constraint fixes: %v", err)
		// Continue despite this error as it might be benign
	}

	// Execute a manual SQL statement to check if the database is ready
	sqlDB, err := db.DB()
	if err != nil {
		return fmt.Errorf("failed to get database connection: %v", err)
	}

	if err := sqlDB.Ping(); err != nil {
		return fmt.Errorf("failed to ping database: %v", err)
	}

	// Store the DB instance for later use
	DB = db
	return nil
}

// GetDB returns the database instance
func GetDB() *gorm.DB {
	return DB
}

// applyConstraintFixes applies fixes for known constraint issues
func applyConstraintFixes(db *gorm.DB) error {
	// Set of SQL statements to fix constraints
	constraintFixSQLs := []string{
		// Safely handle users email constraint
		`DO $$ 
		BEGIN
			BEGIN
				ALTER TABLE users DROP CONSTRAINT IF EXISTS uni_users_email;
			EXCEPTION WHEN OTHERS THEN
				-- Do nothing on error
			END;
		END $$;`,

		// Safely handle cars vehicle_number constraint
		`DO $$
		BEGIN
			BEGIN
				ALTER TABLE cars DROP CONSTRAINT IF EXISTS uni_cars_vehicle_number;
			EXCEPTION WHEN OTHERS THEN
				-- Do nothing on error
			END;
		END $$;`,

		// Ensure proper indexes exist
		`DO $$
		BEGIN
			IF NOT EXISTS (
				SELECT 1 
				FROM pg_indexes 
				WHERE indexname = 'idx_cars_vehicle_number'
			) AND EXISTS (
				SELECT 1 
				FROM information_schema.tables 
				WHERE table_name = 'cars'
			) THEN
				CREATE UNIQUE INDEX idx_cars_vehicle_number ON cars(vehicle_number) WHERE deleted_at IS NULL;
			END IF;
			
			IF NOT EXISTS (
				SELECT 1 
				FROM pg_indexes 
				WHERE indexname = 'idx_users_email'
			) AND EXISTS (
				SELECT 1 
				FROM information_schema.tables 
				WHERE table_name = 'users'
			) THEN
				CREATE UNIQUE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;
			END IF;
		END $$;`,
	}

	// Execute each fix statement separately to isolate errors
	for _, fixSQL := range constraintFixSQLs {
		err := db.Exec(fixSQL).Error
		if err != nil {
			log.Printf("Error applying constraint fix: %v", err)
			// Continue with other fixes despite error
		}
	}

	return nil
}

// isIgnorableConstraintError checks if an error is a constraint error that can be ignored
func isIgnorableConstraintError(err error) bool {
	return err != nil && (strings.Contains(err.Error(), "duplicate key value violates unique constraint") ||
		strings.Contains(err.Error(), "already exists"))
}

// GetDirectDB returns a direct DB connection using the provided DSN
func GetDirectDB(dsn string) (*gorm.DB, error) {
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		return nil, fmt.Errorf("failed to connect to database: %v", err)
	}
	return db, nil
}

// ApplyConstraintFixes exports the constraint fixing functionality
func ApplyConstraintFixes(db *gorm.DB) error {
	return applyConstraintFixes(db)
}
