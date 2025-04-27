package main

import (
	"car-rental-backend/config"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	// Load configuration
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	// First, run the constraint fixes to ensure any issues are resolved
	log.Println("Fixing database constraints...")
	fixConstraintsCmd := exec.Command("go", "run", "cmd/api/main.go", "fix-constraints")
	fixConstraintsCmd.Stdout = os.Stdout
	fixConstraintsCmd.Stderr = os.Stderr
	if err := fixConstraintsCmd.Run(); err != nil {
		log.Printf("Warning: Failed to fix constraints: %v", err)
	}

	// Connect to database
	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		cfg.DBHost,
		cfg.DBPort,
		cfg.DBUser,
		cfg.DBPassword,
		cfg.DBName,
		cfg.DBSSLMode,
	)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		DisableForeignKeyConstraintWhenMigrating: true,
	})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Execute each migration file in order
	migrationsDir := "./migrations"
	files, err := os.ReadDir(migrationsDir)
	if err != nil {
		log.Fatalf("Failed to read migrations directory: %v", err)
	}

	// Get all SQL migration files
	var migrationFiles []string
	for _, file := range files {
		if !file.IsDir() && strings.HasSuffix(file.Name(), ".up.sql") {
			migrationFiles = append(migrationFiles, file.Name())
		}
	}

	// Sort migration files to ensure correct order
	sort.Strings(migrationFiles)

	// Execute each migration
	for _, file := range migrationFiles {
		log.Printf("Applying migration: %s", file)
		sqlFile := filepath.Join(migrationsDir, file)
		sqlBytes, err := os.ReadFile(sqlFile)
		if err != nil {
			log.Printf("Error reading migration file %s: %v", file, err)
			continue
		}

		// Execute the SQL
		sqlStatements := string(sqlBytes)
		result := db.Exec(sqlStatements)
		if result.Error != nil {
			if strings.Contains(result.Error.Error(), "constraint") &&
				strings.Contains(result.Error.Error(), "does not exist") {
				log.Printf("Ignoring constraint error in %s: %v", file, result.Error)
				continue
			}
			log.Printf("Error executing migration %s: %v", file, result.Error)
		} else {
			log.Printf("Successfully applied migration: %s", file)
		}
	}

	log.Println("All migrations completed")
}
