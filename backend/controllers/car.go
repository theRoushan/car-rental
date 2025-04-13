package controllers

import (
	"car-rental-backend/database"
	"car-rental-backend/models"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

type CreateCarRequest struct {
	Name         string  `json:"name" validate:"required"`
	Model        string  `json:"model" validate:"required"`
	LicensePlate string  `json:"license_plate" validate:"required"`
	Location     string  `json:"location" validate:"required"`
	HourlyRate   float64 `json:"hourly_rate" validate:"required,min=0"`
}

type UpdateCarRequest struct {
	Name         string  `json:"name"`
	Model        string  `json:"model"`
	LicensePlate string  `json:"license_plate"`
	Location     string  `json:"location"`
	HourlyRate   float64 `json:"hourly_rate"`
	IsAvailable  bool    `json:"is_available"`
}

func CreateCar(c *fiber.Ctx) error {
	var req CreateCarRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	car := models.Car{
		Name:         req.Name,
		Model:        req.Model,
		LicensePlate: req.LicensePlate,
		Location:     req.Location,
		HourlyRate:   req.HourlyRate,
		IsAvailable:  true,
	}

	if result := database.DB.Create(&car); result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to create car",
		})
	}

	return c.Status(fiber.StatusCreated).JSON(car)
}

func GetCars(c *fiber.Ctx) error {
	var cars []models.Car
	if result := database.DB.Find(&cars); result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to fetch cars",
		})
	}

	return c.JSON(cars)
}

func GetCar(c *fiber.Ctx) error {
	id := c.Params("id")
	carID, err := uuid.Parse(id)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid car ID",
		})
	}

	var car models.Car
	if result := database.DB.First(&car, "id = ?", carID); result.Error != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Car not found",
		})
	}

	return c.JSON(car)
}

func UpdateCar(c *fiber.Ctx) error {
	id := c.Params("id")
	carID, err := uuid.Parse(id)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid car ID",
		})
	}

	var car models.Car
	if result := database.DB.First(&car, "id = ?", carID); result.Error != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Car not found",
		})
	}

	var req UpdateCarRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	// Update fields if provided
	if req.Name != "" {
		car.Name = req.Name
	}
	if req.Model != "" {
		car.Model = req.Model
	}
	if req.LicensePlate != "" {
		car.LicensePlate = req.LicensePlate
	}
	if req.Location != "" {
		car.Location = req.Location
	}
	if req.HourlyRate > 0 {
		car.HourlyRate = req.HourlyRate
	}
	car.IsAvailable = req.IsAvailable

	if result := database.DB.Save(&car); result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to update car",
		})
	}

	return c.JSON(car)
}

func DeleteCar(c *fiber.Ctx) error {
	id := c.Params("id")
	carID, err := uuid.Parse(id)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid car ID",
		})
	}

	if result := database.DB.Delete(&models.Car{}, "id = ?", carID); result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to delete car",
		})
	}

	return c.SendStatus(fiber.StatusNoContent)
}

func GetAvailableCars(c *fiber.Ctx) error {
	startTime := c.Query("start")
	endTime := c.Query("end")

	if startTime == "" || endTime == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Start and end times are required",
		})
	}

	start, err := time.Parse(time.RFC3339, startTime)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid start time format",
		})
	}

	end, err := time.Parse(time.RFC3339, endTime)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid end time format",
		})
	}

	if end.Before(start) {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "End time must be after start time",
		})
	}

	var cars []models.Car
	query := database.DB.Where("is_available = ?", true).
		Where("id NOT IN (SELECT car_id FROM bookings WHERE status = ? AND start_time < ? AND end_time > ?)",
			models.BookingStatusBooked, end, start)

	if result := query.Find(&cars); result.Error != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Failed to fetch available cars",
		})
	}

	return c.JSON(cars)
}
