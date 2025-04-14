package main

import (
	"database/sql"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"sort"
	"strings"

	_ "github.com/lib/pq"
)

func main() {
	// Parse command line flags
	up := flag.Bool("up", false, "Run migrations up")
	down := flag.Bool("down", false, "Run migrations down")
	flag.Parse()

	if !*up && !*down {
		fmt.Println("Please specify either -up or -down flag")
		flag.Usage()
		os.Exit(1)
	}

	// Get database connection string from environment variables
	dbHost := getEnv("DB_HOST", "localhost")
	dbPort := getEnv("DB_PORT", "5432")
	dbUser := getEnv("DB_USER", "postgres")
	dbPassword := getEnv("DB_PASSWORD", "postgres")
	dbName := getEnv("DB_NAME", "car_rental")
	dbSSLMode := getEnv("DB_SSL_MODE", "disable")

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
	files, err := ioutil.ReadDir(migrationsDir)
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

	// Run migrations
	if *up {
		runMigrationsUp(db, migrationsDir, migrationFiles, appliedMigrations)
	} else if *down {
		runMigrationsDown(db, migrationsDir, migrationFiles, appliedMigrations)
	}
}

func runMigrationsUp(db *sql.DB, migrationsDir string, migrationFiles []string, appliedMigrations map[string]bool) {
	for _, file := range migrationFiles {
		if !strings.HasSuffix(file, ".up.sql") {
			continue
		}

		migrationName := strings.TrimSuffix(file, ".up.sql")
		if appliedMigrations[migrationName] {
			fmt.Printf("Migration %s already applied, skipping\n", migrationName)
			continue
		}

		fmt.Printf("Applying migration %s...\n", migrationName)
		sqlFile := filepath.Join(migrationsDir, file)
		sql, err := ioutil.ReadFile(sqlFile)
		if err != nil {
			log.Fatalf("Error reading migration file %s: %v", file, err)
		}

		// Start a transaction
		tx, err := db.Begin()
		if err != nil {
			log.Fatalf("Error starting transaction: %v", err)
		}

		// Execute the migration
		_, err = tx.Exec(string(sql))
		if err != nil {
			tx.Rollback()
			log.Fatalf("Error executing migration %s: %v", file, err)
		}

		// Record the migration
		_, err = tx.Exec("INSERT INTO migrations (name) VALUES ($1)", migrationName)
		if err != nil {
			tx.Rollback()
			log.Fatalf("Error recording migration %s: %v", migrationName, err)
		}

		// Commit the transaction
		err = tx.Commit()
		if err != nil {
			log.Fatalf("Error committing transaction: %v", err)
		}

		fmt.Printf("Migration %s applied successfully\n", migrationName)
	}
}

func runMigrationsDown(db *sql.DB, migrationsDir string, migrationFiles []string, appliedMigrations map[string]bool) {
	// Reverse the order of migrations for down migration
	for i := len(migrationFiles) - 1; i >= 0; i-- {
		file := migrationFiles[i]
		if !strings.HasSuffix(file, ".down.sql") {
			continue
		}

		migrationName := strings.TrimSuffix(file, ".down.sql")
		if !appliedMigrations[migrationName] {
			fmt.Printf("Migration %s not applied, skipping\n", migrationName)
			continue
		}

		fmt.Printf("Reverting migration %s...\n", migrationName)
		sqlFile := filepath.Join(migrationsDir, file)
		sql, err := ioutil.ReadFile(sqlFile)
		if err != nil {
			log.Fatalf("Error reading migration file %s: %v", file, err)
		}

		// Start a transaction
		tx, err := db.Begin()
		if err != nil {
			log.Fatalf("Error starting transaction: %v", err)
		}

		// Execute the migration
		_, err = tx.Exec(string(sql))
		if err != nil {
			tx.Rollback()
			log.Fatalf("Error executing migration %s: %v", file, err)
		}

		// Remove the migration record
		_, err = tx.Exec("DELETE FROM migrations WHERE name = $1", migrationName)
		if err != nil {
			tx.Rollback()
			log.Fatalf("Error removing migration record %s: %v", migrationName, err)
		}

		// Commit the transaction
		err = tx.Commit()
		if err != nil {
			log.Fatalf("Error committing transaction: %v", err)
		}

		fmt.Printf("Migration %s reverted successfully\n", migrationName)
	}
}

func getEnv(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}
