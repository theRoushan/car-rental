package main

import (
	"car-rental-backend/config"
	"car-rental-backend/database"
	"car-rental-backend/routes"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
)

func main() {
	// Check for command-line arguments for migration or other operations
	if len(os.Args) > 1 {
		cmd := os.Args[1]
		if cmd == "fix-constraints" {
			fixDatabaseConstraints()
			return
		} else if cmd == "migrate" {
			// Run the new migrator instead of starting the server
			migrateCmd := exec.Command("go", "run", "cmd/migrate/main.go")
			migrateCmd.Stdout = os.Stdout
			migrateCmd.Stderr = os.Stderr
			if err := migrateCmd.Run(); err != nil {
				log.Fatalf("Migration failed: %v", err)
			}
			log.Println("Migration complete. Starting server...")
			startServer()
			return
		}
	}

	// Default: Just start the server
	startServer()
}

// fixDatabaseConstraints runs the constraint fix operations separately
func fixDatabaseConstraints() {
	// Load configuration
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	// Initialize DB connection and apply fixes only
	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		cfg.DBHost,
		cfg.DBPort,
		cfg.DBUser,
		cfg.DBPassword,
		cfg.DBName,
		cfg.DBSSLMode,
	)

	// Connect to database directly and run fixes
	db, err := database.GetDirectDB(dsn)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Apply constraints fix and exit
	err = database.ApplyConstraintFixes(db)
	if err != nil {
		log.Printf("Warning: Some constraint fixes failed: %v", err)
	} else {
		log.Println("Database constraint fixes applied successfully")
	}
}

// startServer starts the API server
func startServer() {
	// Load configuration
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

	// Initialize database
	if err := database.InitDB(cfg); err != nil {
		if strings.Contains(err.Error(), "constraint \"uni_cars_vehicle_number\" of relation \"cars\" does not exist") {
			fmt.Println("Ignoring constraint error, continuing with initialization...")
		} else {
			log.Fatalf("Failed to initialize database: %v", err)
		}
	}

	// Create Fiber app
	app := fiber.New(fiber.Config{
		ErrorHandler: func(c *fiber.Ctx, err error) error {
			code := fiber.StatusInternalServerError
			var message string

			// Check for fiber errors
			if e, ok := err.(*fiber.Error); ok {
				code = e.Code
				message = e.Message
			} else {
				// Default error message for non-fiber errors
				message = err.Error()
			}

			// Log the error for serious issues
			if code >= 500 {
				log.Printf("Server error: %v", err)
			}

			// Return JSON error response
			return c.Status(code).JSON(fiber.Map{
				"success": false,
				"error":   message,
				"code":    code,
			})
		},
	})

	// Middleware
	app.Use(recover.New())
	app.Use(logger.New())
	app.Use(cors.New(cors.Config{
		AllowOrigins: "*",
		AllowHeaders: "Origin, Content-Type, Accept, Authorization",
		AllowMethods: "GET, POST, PUT, DELETE",
	}))

	// Setup routes
	routes.SetupRoutes(app, cfg)

	// Start server
	log.Printf("Server starting on port %s", cfg.Port)
	if err := app.Listen(":" + cfg.Port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
