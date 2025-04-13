package routes

import (
	"car-rental-backend/config"
	"car-rental-backend/controllers"
	"car-rental-backend/middlewares"

	"github.com/gofiber/fiber/v2"
)

func SetupRoutes(app *fiber.App, cfg *config.Config) {
	// Store config in app context
	app.Use(func(c *fiber.Ctx) error {
		c.Locals("config", cfg)
		return c.Next()
	})

	// Public routes
	auth := app.Group("/auth")
	auth.Post("/register", controllers.Register)
	auth.Post("/login", controllers.Login)

	// Protected routes
	api := app.Group("/api", middlewares.AuthMiddleware(cfg))

	// Car routes
	cars := api.Group("/cars")
	cars.Get("/", controllers.GetCars)
	cars.Get("/available", controllers.GetAvailableCars)
	cars.Get("/:id", controllers.GetCar)
	cars.Post("/", controllers.CreateCar)
	cars.Put("/:id", controllers.UpdateCar)
	cars.Delete("/:id", controllers.DeleteCar)

	// Booking routes
	bookings := api.Group("/bookings")
	bookings.Post("/", controllers.CreateBooking)
	bookings.Get("/:id", controllers.GetBooking)
	bookings.Delete("/:id", controllers.CancelBooking)

	// User bookings
	users := api.Group("/users")
	users.Get("/:userId/bookings", controllers.GetUserBookings)
}
