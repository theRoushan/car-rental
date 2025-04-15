package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/lib/pq"
)

func main() {
	// Get database connection string from environment variables
	dbHost := getEnvVar("DB_HOST", "localhost")
	dbPort := getEnvVar("DB_PORT", "5432")
	dbUser := getEnvVar("DB_USER", "postgres")
	dbPassword := getEnvVar("DB_PASSWORD", "postgres")
	dbName := getEnvVar("DB_NAME", "car_rental")
	dbSSLMode := getEnvVar("DB_SSL_MODE", "disable")

	connStr := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		dbHost, dbPort, dbUser, dbPassword, dbName, dbSSLMode)

	// Connect to the database
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("Error connecting to database: %v", err)
	}
	defer db.Close()

	// Test the connection
	err = db.Ping()
	if err != nil {
		log.Fatalf("Error pinging database: %v", err)
	}

	// Fix the constraint issue
	fixScript := `
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
			CREATE UNIQUE INDEX idx_cars_vehicle_number ON cars(vehicle_number);
		END IF;
	END$$;
	`

	_, err = db.Exec(fixScript)
	if err != nil {
		log.Fatalf("Error fixing database: %v", err)
	}

	fmt.Println("Database fix applied successfully!")
}

func getEnvVar(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}
