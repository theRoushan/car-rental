package main

import (
	"database/sql"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"car-rental-backend/config"

	_ "github.com/lib/pq"
)

func main() {
	// Parse command line flags
	up := flag.Bool("up", false, "Run migrations up")
	down := flag.Bool("down", false, "Run migrations down")
	specific := flag.String("migration", "", "Run a specific migration (provide name without .up.sql or .down.sql)")
	flag.Parse()

	if !*up && !*down {
		fmt.Println("Please specify either -up or -down flag")
		flag.Usage()
		os.Exit(1)
	}

	// Load environment variables
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Error loading config: %v", err)
	}

	// Create database connection string
	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		cfg.DBHost,
		cfg.DBPort,
		cfg.DBUser,
		cfg.DBPassword,
		cfg.DBName,
		cfg.DBSSLMode,
	)

	// Connect to the database
	db, err := sql.Open("postgres", dsn)
	if err != nil {
		log.Fatalf("Error connecting to database: %v", err)
	}
	defer db.Close()

	// Test the connection
	err = db.Ping()
	if err != nil {
		log.Fatalf("Error pinging database: %v", err)
	}

	// Create migrations table if it doesn't exist
	_, err = db.Exec(`
		CREATE TABLE IF NOT EXISTS migrations (
			id SERIAL PRIMARY KEY,
			name VARCHAR(255) NOT NULL UNIQUE,
			applied_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
		)
	`)
	if err != nil {
		log.Fatalf("Error creating migrations table: %v", err)
	}

	// Get list of migration files
	migrationsDir := "./migrations"
	files, err := os.ReadDir(migrationsDir)
	if err != nil {
		log.Fatalf("Error reading migrations directory: %v", err)
	}

	// Filter and sort migration files
	var migrationFiles []string
	for _, file := range files {
		if !file.IsDir() && strings.HasSuffix(file.Name(), ".sql") {
			migrationFiles = append(migrationFiles, file.Name())
		}
	}
	sort.Strings(migrationFiles)

	// Get applied migrations
	rows, err := db.Query("SELECT name FROM migrations ORDER BY id")
	if err != nil {
		log.Fatalf("Error querying applied migrations: %v", err)
	}
	defer rows.Close()

	appliedMigrations := make(map[string]bool)
	for rows.Next() {
		var name string
		if err := rows.Scan(&name); err != nil {
			log.Fatalf("Error scanning migration name: %v", err)
		}
		appliedMigrations[name] = true
	}

	// If a specific migration is specified, filter to only that migration
	if *specific != "" {
		var specificFiles []string
		for _, file := range migrationFiles {
			if strings.HasPrefix(file, *specific) || strings.Contains(file, "_"+*specific+".") {
				specificFiles = append(specificFiles, file)
			}
		}
		if len(specificFiles) == 0 {
			log.Fatalf("No migration files found matching: %s", *specific)
		}
		migrationFiles = specificFiles
	}

	// Run migrations
	if *up {
		runMigrationsUp(db, migrationsDir, migrationFiles, appliedMigrations)
	} else if *down {
		runMigrationsDown(db, migrationsDir, migrationFiles, appliedMigrations)
	}
}

func runMigrationsUp(db *sql.DB, migrationsDir string, migrationFiles []string, appliedMigrations map[string]bool) {
	successCount := 0
	skippedCount := 0
	failedCount := 0

	for _, file := range migrationFiles {
		if !strings.HasSuffix(file, ".up.sql") {
			continue
		}

		migrationName := strings.TrimSuffix(file, ".up.sql")
		if appliedMigrations[migrationName] {
			fmt.Printf("Migration %s already applied, skipping\n", migrationName)
			skippedCount++
			continue
		}

		fmt.Printf("Applying migration %s...\n", migrationName)
		sqlFile := filepath.Join(migrationsDir, file)
		sqlBytes, err := os.ReadFile(sqlFile)
		if err != nil {
			log.Printf("Error reading migration file %s: %v", file, err)
			failedCount++
			continue
		}
		sql := string(sqlBytes)

		// Start a transaction
		tx, err := db.Begin()
		if err != nil {
			log.Printf("Error starting transaction: %v", err)
			failedCount++
			continue
		}

		// Execute the migration
		_, err = tx.Exec(sql)
		if err != nil {
			tx.Rollback()
			log.Printf("Error executing migration %s: %v", file, err)
			failedCount++
			continue
		}

		// Record the migration
		_, err = tx.Exec("INSERT INTO migrations (name) VALUES ($1)", migrationName)
		if err != nil {
			tx.Rollback()
			log.Printf("Error recording migration %s: %v", migrationName, err)
			failedCount++
			continue
		}

		// Commit the transaction
		err = tx.Commit()
		if err != nil {
			log.Printf("Error committing transaction: %v", err)
			failedCount++
			continue
		}

		fmt.Printf("Migration %s applied successfully\n", migrationName)
		successCount++
	}

	fmt.Printf("\nMigration summary: %d successful, %d skipped, %d failed\n",
		successCount, skippedCount, failedCount)
}

func runMigrationsDown(db *sql.DB, migrationsDir string, migrationFiles []string, appliedMigrations map[string]bool) {
	// Reverse the order of migrations for down migration
	for i, j := 0, len(migrationFiles)-1; i < j; i, j = i+1, j-1 {
		migrationFiles[i], migrationFiles[j] = migrationFiles[j], migrationFiles[i]
	}

	successCount := 0
	skippedCount := 0
	failedCount := 0

	for _, file := range migrationFiles {
		if !strings.HasSuffix(file, ".down.sql") {
			continue
		}

		migrationName := strings.TrimSuffix(file, ".down.sql")
		if !appliedMigrations[migrationName] {
			fmt.Printf("Migration %s not applied, skipping\n", migrationName)
			skippedCount++
			continue
		}

		fmt.Printf("Reverting migration %s...\n", migrationName)
		sqlFile := filepath.Join(migrationsDir, file)
		sqlBytes, err := os.ReadFile(sqlFile)
		if err != nil {
			log.Printf("Error reading migration file %s: %v", file, err)
			failedCount++
			continue
		}
		sql := string(sqlBytes)

		// Start a transaction
		tx, err := db.Begin()
		if err != nil {
			log.Printf("Error starting transaction: %v", err)
			failedCount++
			continue
		}

		// Execute the migration
		_, err = tx.Exec(sql)
		if err != nil {
			tx.Rollback()
			log.Printf("Error executing migration %s: %v", file, err)
			failedCount++
			continue
		}

		// Remove the migration record
		_, err = tx.Exec("DELETE FROM migrations WHERE name = $1", migrationName)
		if err != nil {
			tx.Rollback()
			log.Printf("Error removing migration record %s: %v", migrationName, err)
			failedCount++
			continue
		}

		// Commit the transaction
		err = tx.Commit()
		if err != nil {
			log.Printf("Error committing transaction: %v", err)
			failedCount++
			continue
		}

		fmt.Printf("Migration %s reverted successfully\n", migrationName)
		successCount++
	}

	fmt.Printf("\nMigration summary: %d successful, %d skipped, %d failed\n",
		successCount, skippedCount, failedCount)
}
