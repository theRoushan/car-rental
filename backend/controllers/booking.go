package controllers

import (
	"car-rental-backend/database"
	"car-rental-backend/models"
	"car-rental-backend/services"
	"car-rental-backend/utils"
	"fmt"
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
		fmt.Println("Parsing error:", err.Error())
		return utils.ValidationErrorResponse(c, "Invalid request body", []string{
			"Failed to parse request body: " + err.Error(),
		})
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
	if result := database.DB.Preload("CurrentStatus").Preload("RentalInfo").First(&car, "id = ?", carID); result.Error != nil {
		return utils.NotFoundResponse(c, "Car not found")
	}

	if car.CurrentStatus == nil || !car.CurrentStatus.IsAvailable {
		return utils.ConflictResponse(c, "Car is not available", nil)
	}

	// Check for booking conflicts
	var conflictCount int64
	database.DB.Model(&models.Booking{}).
		Where("car_id = ? AND status = ? AND start_time < ? AND end_time > ?",
			carID, models.BookingStatusBooked, req.EndTime, req.StartTime).
		Count(&conflictCount)

	if conflictCount > 0 {
		return utils.ConflictResponse(c, "Car is already booked for this time period", nil)
	}

	// Calculate total price
	hours := req.EndTime.Sub(req.StartTime).Hours()
	var totalPrice float64

	if car.RentalInfo == nil {
		return utils.ServerErrorResponse(c, "Car rental information is missing")
	}

	if hours <= 24 {
		// Use hourly rate for bookings less than 24 hours
		totalPrice = hours * car.RentalInfo.RentalPricePerHour
	} else {
		// Use daily rate for bookings more than 24 hours
		days := hours / 24
		totalPrice = days * car.RentalInfo.RentalPricePerDay
	}

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

	// Update car status
	carService := services.NewCarService()
	if err := carService.UpdateCarAvailability(carID, false); err != nil {
		return utils.ServerErrorResponse(c, "Failed to update car status")
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

func GetAllBookings(c *fiber.Ctx) error {
	// Check if user is admin
	userRole := c.Locals("user_role").(string)
	if userRole != "admin" {
		return utils.ForbiddenResponse(c, "Only admin users can access this resource")
	}

	// Get pagination parameters
	page, pageSize := utils.GetPaginationParams(c)
	offset := (page - 1) * pageSize

	var bookings []models.Booking
	var totalCount int64

	// Start building the query
	query := database.DB.Model(&models.Booking{})
	countQuery := database.DB.Model(&models.Booking{})

	// Apply filters if provided
	statusFilter := c.Query("status")
	if statusFilter != "" {
		query = query.Where("status = ?", statusFilter)
		countQuery = countQuery.Where("status = ?", statusFilter)
	}

	// Add date range filters if provided
	startDate := c.Query("start_date")
	if startDate != "" {
		query = query.Where("start_time >= ?", startDate)
		countQuery = countQuery.Where("start_time >= ?", startDate)
	}

	endDate := c.Query("end_date")
	if endDate != "" {
		query = query.Where("end_time <= ?", endDate)
		countQuery = countQuery.Where("end_time <= ?", endDate)
	}

	// Check for car_id filter
	carID := c.Query("car_id")
	if carID != "" {
		query = query.Where("car_id = ?", carID)
		countQuery = countQuery.Where("car_id = ?", carID)
	}

	// Check for user_id filter
	userIDFilter := c.Query("user_id")
	if userIDFilter != "" {
		query = query.Where("user_id = ?", userIDFilter)
		countQuery = countQuery.Where("user_id = ?", userIDFilter)
	}

	// Get total count for pagination
	if result := countQuery.Count(&totalCount); result.Error != nil {
		return utils.ServerErrorResponse(c, "Failed to count bookings")
	}

	// Get paginated bookings with car and user data
	if result := query.Preload("Car").Preload("User").
		Limit(pageSize).Offset(offset).
		Order("created_at DESC").
		Find(&bookings); result.Error != nil {
		return utils.ServerErrorResponse(c, "Failed to fetch bookings")
	}

	// Use the standard pagination helper
	pagination := models.NewPagination(totalCount, page, pageSize)

	return utils.PaginatedSuccessResponse(c, bookings, pagination, "All bookings fetched successfully")
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

	// Make the car available again
	carService := services.NewCarService()
	if err := carService.UpdateCarAvailability(booking.CarID, true); err != nil {
		return utils.ServerErrorResponse(c, "Failed to update car availability")
	}

	return utils.SuccessResponse(c, booking, "Booking cancelled successfully")
}
