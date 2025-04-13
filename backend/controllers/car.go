package controllers

import (
	"car-rental-backend/database"
	"car-rental-backend/models"
	"car-rental-backend/utils"
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
		return utils.ValidationErrorResponse(c, "Invalid request body", []string{"Failed to parse request body"})
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
		return utils.ServerErrorResponse(c, "Failed to create car")
	}

	return utils.SuccessResponse(c, car, "Car created successfully")
}

func GetCars(c *fiber.Ctx) error {
	var cars []models.Car
	if result := database.DB.Find(&cars); result.Error != nil {
		return utils.ServerErrorResponse(c, "Failed to fetch cars")
	}

	return utils.SuccessResponse(c, cars, "Cars fetched successfully")
}

func GetCar(c *fiber.Ctx) error {
	id := c.Params("id")
	carID, err := uuid.Parse(id)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid car ID", []string{"Invalid UUID format"})
	}

	var car models.Car
	if result := database.DB.First(&car, "id = ?", carID); result.Error != nil {
		return utils.NotFoundResponse(c, "Car not found")
	}

	return utils.SuccessResponse(c, car, "Car fetched successfully")
}

func UpdateCar(c *fiber.Ctx) error {
	id := c.Params("id")
	carID, err := uuid.Parse(id)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid car ID", []string{"Invalid UUID format"})
	}

	var car models.Car
	if result := database.DB.First(&car, "id = ?", carID); result.Error != nil {
		return utils.NotFoundResponse(c, "Car not found")
	}

	var req UpdateCarRequest
	if err := c.BodyParser(&req); err != nil {
		return utils.ValidationErrorResponse(c, "Invalid request body", []string{"Failed to parse request body"})
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
		return utils.ServerErrorResponse(c, "Failed to update car")
	}

	return utils.SuccessResponse(c, car, "Car updated successfully")
}

func DeleteCar(c *fiber.Ctx) error {
	id := c.Params("id")
	carID, err := uuid.Parse(id)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid car ID", []string{"Invalid UUID format"})
	}

	if result := database.DB.Delete(&models.Car{}, "id = ?", carID); result.Error != nil {
		return utils.ServerErrorResponse(c, "Failed to delete car")
	}

	return utils.SuccessResponse(c, nil, "Car deleted successfully")
}

func GetAvailableCars(c *fiber.Ctx) error {
	startTime := c.Query("start")
	endTime := c.Query("end")

	if startTime == "" || endTime == "" {
		return utils.ValidationErrorResponse(c, "Start and end times are required", []string{"Missing required query parameters"})
	}

	start, err := time.Parse(time.RFC3339, startTime)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid start time format", []string{"Start time must be in RFC3339 format"})
	}

	end, err := time.Parse(time.RFC3339, endTime)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid end time format", []string{"End time must be in RFC3339 format"})
	}

	if end.Before(start) {
		return utils.ValidationErrorResponse(c, "End time must be after start time", []string{"Invalid time range"})
	}

	var cars []models.Car
	query := database.DB.Where("is_available = ?", true).
		Where("id NOT IN (SELECT car_id FROM bookings WHERE status = ? AND start_time < ? AND end_time > ?)",
			models.BookingStatusBooked, end, start)

	if result := query.Find(&cars); result.Error != nil {
		return utils.ServerErrorResponse(c, "Failed to fetch available cars")
	}

	return utils.SuccessResponse(c, cars, "Available cars fetched successfully")
}
