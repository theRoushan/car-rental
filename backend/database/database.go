package database

import (
	"car-rental-backend/config"
	"car-rental-backend/models"
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

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		return fmt.Errorf("failed to connect to database: %v", err)
	}

	// Apply known error-prone migrations first using SQL Exec
	if err := applyConstraintFixes(db); err != nil {
		log.Printf("Warning: Failed to apply constraint fixes: %v", err)
		// Continue despite this error as it might be benign
	}

	// Auto Migrate the schema
	err = db.AutoMigrate(
		&models.User{},
		&models.Car{},
		&models.Booking{},
		&models.Owner{},
		&models.CarRentalInfo{},
		&models.CarMedia{},
		&models.CarStatus{},
	)
	if err != nil {
		// If the error is about the constraint that doesn't exist, we can ignore it
		if isIgnorableConstraintError(err) {
			log.Println("Ignoring constraint error, continuing with initialization...")
		} else {
			return fmt.Errorf("failed to migrate database: %v", err)
		}
	}

	DB = db
	return nil
}

// GetDB returns the database instance
func GetDB() *gorm.DB {
	return DB
}

// applyConstraintFixes applies fixes for known constraint issues
func applyConstraintFixes(db *gorm.DB) error {
	// SQL to safely drop the constraint if it exists
	constraintFixSQL := `
	DO $$
	BEGIN
		-- Check if the constraint exists in the information schema
		IF EXISTS (
			SELECT 1 
			FROM pg_constraint 
			WHERE conname = 'uni_cars_vehicle_number'
		) THEN
			-- If it exists, drop it
			ALTER TABLE cars DROP CONSTRAINT uni_cars_vehicle_number;
		END IF;
		
		-- Ensure vehicle_number has a unique index with the correct name
		IF NOT EXISTS (
			SELECT 1 
			FROM pg_indexes 
			WHERE indexname = 'idx_cars_vehicle_number'
		) THEN
			CREATE UNIQUE INDEX idx_cars_vehicle_number ON cars(vehicle_number) WHERE deleted_at IS NULL;
		END IF;
	END$$;
	`

	return db.Exec(constraintFixSQL).Error
}

// isIgnorableConstraintError checks if an error is a constraint error that can be ignored
func isIgnorableConstraintError(err error) bool {
	return err != nil && (strings.Contains(err.Error(), "constraint \"uni_cars_vehicle_number\" of relation \"cars\" does not exist") ||
		strings.Contains(err.Error(), "duplicate key value violates unique constraint") ||
		strings.Contains(err.Error(), "already exists"))
}
