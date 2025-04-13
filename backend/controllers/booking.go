package controllers

import (
	"car-rental-backend/database"
	"car-rental-backend/models"
	"car-rental-backend/utils"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

type CreateBookingRequest struct {
	CarID     string    `json:"car_id" validate:"required"`
	StartTime time.Time `json:"start_time" validate:"required"`
	EndTime   time.Time `json:"end_time" validate:"required"`
}

func CreateBooking(c *fiber.Ctx) error {
	var req CreateBookingRequest
	if err := c.BodyParser(&req); err != nil {
		return utils.ValidationErrorResponse(c, "Invalid request body", []string{"Failed to parse request body"})
	}

	// Validate time range
	if req.EndTime.Before(req.StartTime) {
		return utils.ValidationErrorResponse(c, "End time must be after start time", []string{"Invalid time range"})
	}

	// Parse car ID
	carID, err := uuid.Parse(req.CarID)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid car ID", []string{"Invalid UUID format"})
	}

	// Get user ID from context (set by auth middleware)
	userID, err := uuid.Parse(c.Locals("user_id").(string))
	if err != nil {
		return utils.ServerErrorResponse(c, "Invalid user ID")
	}

	// Check if car exists and is available
	var car models.Car
	if result := database.DB.First(&car, "id = ?", carID); result.Error != nil {
		return utils.NotFoundResponse(c, "Car not found")
	}

	if !car.IsAvailable {
		return utils.ConflictResponse(c, "Car is not available")
	}

	// Check for booking conflicts
	var conflictCount int64
	database.DB.Model(&models.Booking{}).
		Where("car_id = ? AND status = ? AND start_time < ? AND end_time > ?",
			carID, models.BookingStatusBooked, req.EndTime, req.StartTime).
		Count(&conflictCount)

	if conflictCount > 0 {
		return utils.ConflictResponse(c, "Car is already booked for this time period")
	}

	// Calculate total price
	hours := req.EndTime.Sub(req.StartTime).Hours()
	totalPrice := hours * car.HourlyRate

	// Create booking
	booking := models.Booking{
		UserID:     userID,
		CarID:      carID,
		StartTime:  req.StartTime,
		EndTime:    req.EndTime,
		Status:     models.BookingStatusBooked,
		TotalPrice: totalPrice,
	}

	if result := database.DB.Create(&booking); result.Error != nil {
		return utils.ServerErrorResponse(c, "Failed to create booking")
	}

	return utils.SuccessResponse(c, booking, "Booking created successfully")
}

func GetBooking(c *fiber.Ctx) error {
	id := c.Params("id")
	bookingID, err := uuid.Parse(id)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid booking ID", []string{"Invalid UUID format"})
	}

	var booking models.Booking
	if result := database.DB.Preload("User").Preload("Car").First(&booking, "id = ?", bookingID); result.Error != nil {
		return utils.NotFoundResponse(c, "Booking not found")
	}

	// Check if the user is authorized to view this booking
	userID := c.Locals("user_id").(string)
	if booking.UserID.String() != userID {
		return utils.ForbiddenResponse(c, "Not authorized to view this booking")
	}

	return utils.SuccessResponse(c, booking, "Booking fetched successfully")
}

func GetUserBookings(c *fiber.Ctx) error {
	userID := c.Locals("user_id").(string)

	var bookings []models.Booking
	if result := database.DB.Preload("Car").Where("user_id = ?", userID).Find(&bookings); result.Error != nil {
		return utils.ServerErrorResponse(c, "Failed to fetch bookings")
	}

	return utils.SuccessResponse(c, bookings, "User bookings fetched successfully")
}

func CancelBooking(c *fiber.Ctx) error {
	id := c.Params("id")
	bookingID, err := uuid.Parse(id)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid booking ID", []string{"Invalid UUID format"})
	}

	var booking models.Booking
	if result := database.DB.First(&booking, "id = ?", bookingID); result.Error != nil {
		return utils.NotFoundResponse(c, "Booking not found")
	}

	// Check if the user is authorized to cancel this booking
	userID := c.Locals("user_id").(string)
	if booking.UserID.String() != userID {
		return utils.ForbiddenResponse(c, "Not authorized to cancel this booking")
	}

	// Check if booking is already cancelled or completed
	if booking.Status != models.BookingStatusBooked {
		return utils.ValidationErrorResponse(c, "Booking is already "+string(booking.Status), []string{"Invalid booking status"})
	}

	// Update booking status
	booking.Status = models.BookingStatusCancelled
	if result := database.DB.Save(&booking); result.Error != nil {
		return utils.ServerErrorResponse(c, "Failed to cancel booking")
	}

	return utils.SuccessResponse(c, booking, "Booking cancelled successfully")
}
