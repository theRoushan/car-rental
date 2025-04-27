package controllers

import (
	"car-rental-backend/models"
	"car-rental-backend/services"
	"car-rental-backend/utils"
	"fmt"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

// CreateCarRequest represents the request body for creating a new car
type CreateCarRequest struct {
	// Basic Car Details
	Make            string `json:"make" validate:"required"`
	Model           string `json:"model" validate:"required"`
	Year            int    `json:"year" validate:"required,min=1900,max=2024"`
	Variant         string `json:"variant" validate:"required"`
	FuelType        string `json:"fuel_type" validate:"required,oneof=Petrol Diesel Electric Hybrid"`
	Transmission    string `json:"transmission" validate:"required,oneof=Manual Automatic CVT"`
	BodyType        string `json:"body_type" validate:"required,oneof=Sedan SUV Hatchback Coupe Van Truck"`
	Color           string `json:"color" validate:"required"`
	SeatingCapacity int    `json:"seating_capacity" validate:"required,min=1,max=50"`
	VehicleNumber   string `json:"vehicle_number" validate:"required"`

	// Rental Info
	RentalInfo struct {
		RentalPricePerDay      float64 `json:"rental_price_per_day" validate:"required,min=0"`
		RentalPricePerHour     float64 `json:"rental_price_per_hour" validate:"required,min=0"`
		MinimumRentDuration    int     `json:"minimum_rent_duration" validate:"required,min=1"`
		SecurityDeposit        float64 `json:"security_deposit" validate:"required,min=0"`
		LateFeePerHour         float64 `json:"late_fee_per_hour" validate:"required,min=0"`
		RentalExtendFeePerDay  float64 `json:"rental_extend_fee_per_day" validate:"required,min=0"`
		RentalExtendFeePerHour float64 `json:"rental_extend_fee_per_hour" validate:"required,min=0"`
	} `json:"rental_info" validate:"required"`

	// Media
	Media struct {
		Images []string `json:"images" validate:"required,min=1"`
		Video  *string  `json:"video,omitempty"`
	} `json:"media" validate:"required"`

	// Status Info
	Status struct {
		IsAvailable            bool     `json:"is_available"`
		CurrentOdometerReading float64  `json:"current_odometer_reading" validate:"required,min=0"`
		DamagesOrIssues        []string `json:"damages_or_issues,omitempty"`
	} `json:"status" validate:"required"`

	// Owner Info
	Owner struct {
		OwnerID uuid.UUID `json:"owner_id" validate:"required"`
	} `json:"owner" validate:"required"`
}

// UpdateCarRequest represents the request body for updating a car
type UpdateCarRequest struct {
	// Basic Car Details
	Make            *string `json:"make,omitempty"`
	Model           *string `json:"model,omitempty"`
	Year            *int    `json:"year,omitempty"`
	Variant         *string `json:"variant,omitempty"`
	FuelType        *string `json:"fuel_type,omitempty"`
	Transmission    *string `json:"transmission,omitempty"`
	BodyType        *string `json:"body_type,omitempty"`
	Color           *string `json:"color,omitempty"`
	SeatingCapacity *int    `json:"seating_capacity,omitempty"`
	VehicleNumber   *string `json:"vehicle_number,omitempty"`

	// Rental Info
	RentalInfo *struct {
		RentalPricePerDay      *float64 `json:"rental_price_per_day,omitempty"`
		RentalPricePerHour     *float64 `json:"rental_price_per_hour,omitempty"`
		MinimumRentDuration    *int     `json:"minimum_rent_duration,omitempty"`
		SecurityDeposit        *float64 `json:"security_deposit,omitempty"`
		LateFeePerHour         *float64 `json:"late_fee_per_hour,omitempty"`
		RentalExtendFeePerDay  *float64 `json:"rental_extend_fee_per_day,omitempty"`
		RentalExtendFeePerHour *float64 `json:"rental_extend_fee_per_hour,omitempty"`
	} `json:"rental_info,omitempty"`

	// Media
	Media *struct {
		AddImages    []string `json:"add_images,omitempty"`
		RemoveImages []string `json:"remove_images,omitempty"`
		Video        *string  `json:"video,omitempty"`
	} `json:"media,omitempty"`

	// Status Info
	Status *struct {
		IsAvailable            *bool     `json:"is_available,omitempty"`
		CurrentOdometerReading *float64  `json:"current_odometer_reading,omitempty"`
		DamagesOrIssues        *[]string `json:"damages_or_issues,omitempty"`
	} `json:"status,omitempty"`

	// Owner Info
	Owner *struct {
		OwnerID     *uuid.UUID `json:"owner_id,omitempty"`
		OwnerName   *string    `json:"owner_name,omitempty"`
		ContactInfo *string    `json:"contact_info,omitempty"`
	} `json:"owner,omitempty"`
}

func CreateCar(c *fiber.Ctx) error {
	var req CreateCarRequest
	if err := c.BodyParser(&req); err != nil {
		return utils.ValidationErrorResponse(c, "Invalid request body", []string{
			"Failed to parse request body: " + err.Error(),
		})
	}

	// Validate request
	if validationErrors := utils.ValidateStruct(req); len(validationErrors) > 0 {
		return utils.ValidationErrorResponse(c, "Validation failed", validationErrors)
	}

	// Validate vehicle number format and check if it already exists
	carService := services.NewCarService()
	exists, err := carService.VehicleNumberExists(req.VehicleNumber)
	if err != nil {
		return utils.ServerErrorResponse(c, "Failed to validate vehicle number: "+err.Error())
	}
	if exists {
		return utils.ValidationErrorResponse(c, "Duplicate vehicle number", []string{
			"Vehicle number " + req.VehicleNumber + " is already registered in the system",
		})
	}

	// Create the car with basic details
	car := &models.Car{
		Make:            req.Make,
		Model:           req.Model,
		Year:            req.Year,
		Variant:         req.Variant,
		FuelType:        models.FuelType(req.FuelType),
		Transmission:    models.TransmissionType(req.Transmission),
		BodyType:        models.BodyType(req.BodyType),
		Color:           req.Color,
		SeatingCapacity: req.SeatingCapacity,
		VehicleNumber:   req.VehicleNumber,
		OwnerID:         req.Owner.OwnerID,
	}

	// Verify that the owner exists
	ownerExists, err := carService.OwnerExists(req.Owner.OwnerID)
	if err != nil {
		return utils.ServerErrorResponse(c, "Failed to validate owner: "+err.Error())
	}
	if !ownerExists {
		return utils.ValidationErrorResponse(c, "Invalid owner", []string{
			"The specified owner ID does not exist",
		})
	}

	rentalInfo := &models.CarRentalInfo{
		RentalPricePerDay:      req.RentalInfo.RentalPricePerDay,
		RentalPricePerHour:     req.RentalInfo.RentalPricePerHour,
		MinimumRentDuration:    req.RentalInfo.MinimumRentDuration,
		SecurityDeposit:        req.RentalInfo.SecurityDeposit,
		LateFeePerHour:         req.RentalInfo.LateFeePerHour,
		RentalExtendFeePerDay:  req.RentalInfo.RentalExtendFeePerDay,
		RentalExtendFeePerHour: req.RentalInfo.RentalExtendFeePerHour,
	}

	status := &models.CarStatus{
		IsAvailable:            req.Status.IsAvailable,
		CurrentOdometerReading: req.Status.CurrentOdometerReading,
		DamagesOrIssues:        req.Status.DamagesOrIssues,
	}

	// Validate media
	if len(req.Media.Images) == 0 {
		return utils.ValidationErrorResponse(c, "Invalid media", []string{
			"At least one image must be provided",
		})
	}

	// Create media entries
	var mediaEntries []models.CarMedia
	for i, imgURL := range req.Media.Images {
		// Validate image URL format
		if !utils.IsValidURL(imgURL) {
			return utils.ValidationErrorResponse(c, "Invalid image URL", []string{
				fmt.Sprintf("Image URL at position %d is not a valid URL", i),
			})
		}
		mediaEntry := models.CarMedia{
			Type:      "image",
			URL:       imgURL,
			IsPrimary: i == 0, // First image is primary
		}
		mediaEntries = append(mediaEntries, mediaEntry)
	}

	if req.Media.Video != nil {
		// Validate video URL format
		if !utils.IsValidURL(*req.Media.Video) {
			return utils.ValidationErrorResponse(c, "Invalid video URL", []string{
				"Video URL is not a valid URL",
			})
		}
		mediaEntry := models.CarMedia{
			Type: "video",
			URL:  *req.Media.Video,
		}
		mediaEntries = append(mediaEntries, mediaEntry)
	}

	// Create the car with all related entities in a transaction
	createdCar, err := carService.CreateCarWithoutDocAndLoc(car, req.Owner.OwnerID, rentalInfo, mediaEntries, status)
	if err != nil {
		// Use the database error handler for better error responses
		return utils.HandleDatabaseError(c, err)
	}

	// Convert to response format
	response := createdCar.ToCarResponse()

	return utils.SuccessResponse(c, response, "Car created successfully")
}

func GetCars(c *fiber.Ctx) error {
	// Get pagination parameters from request
	page, pageSize := utils.GetPaginationParams(c)

	// Get filter parameters
	filters := map[string]interface{}{
		"make":         utils.GetStringParam(c, "make"),
		"model":        utils.GetStringParam(c, "model"),
		"year":         utils.GetIntParam(c, "year", 0),
		"min_year":     utils.GetIntParam(c, "min_year", 0),
		"max_year":     utils.GetIntParam(c, "max_year", 0),
		"fuel_type":    utils.GetStringParam(c, "fuel_type"),
		"transmission": utils.GetStringParam(c, "transmission"),
		"body_type":    utils.GetStringParam(c, "body_type"),
	}

	carService := services.NewCarService()

	// Get paginated cars with filters
	cars, totalItems, err := carService.GetAllCarsPaginated(page, pageSize, filters)
	if err != nil {
		return utils.ServerErrorResponse(c, "Failed to fetch cars: "+err.Error())
	}

	// Create pagination metadata
	pagination := models.NewPagination(totalItems, page, pageSize)

	// Convert cars to response format
	var responses []models.CarResponse
	for _, car := range cars {
		responses = append(responses, car.ToCarResponse())
	}

	return utils.PaginatedSuccessResponse(c, responses, pagination, "Cars fetched successfully")
}

func GetCar(c *fiber.Ctx) error {
	id := c.Params("id")
	carID, err := uuid.Parse(id)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid car ID", []string{"Invalid UUID format"})
	}

	carService := services.NewCarService()
	car, err := carService.GetCarByID(carID)
	if err != nil {
		return utils.NotFoundResponse(c, "Car not found")
	}

	// Convert to response format
	response := car.ToCarResponse()

	return utils.SuccessResponse(c, response, "Car fetched successfully")
}

func UpdateCar(c *fiber.Ctx) error {
	id := c.Params("id")
	carID, err := uuid.Parse(id)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid car ID", []string{"Invalid UUID format"})
	}

	carService := services.NewCarService()

	// Check if car exists
	existingCar, err := carService.GetCarByID(carID)
	if err != nil {
		return utils.NotFoundResponse(c, "Car not found")
	}

	var req UpdateCarRequest
	if err := c.BodyParser(&req); err != nil {
		return utils.ValidationErrorResponse(c, "Invalid request body", []string{
			"Failed to parse request body: " + err.Error(),
		})
	}

	// Validate request
	if validationErrors := utils.ValidateStruct(req); len(validationErrors) > 0 {
		return utils.ValidationErrorResponse(c, "Validation failed", validationErrors)
	}

	// Prepare update maps for different entities
	carUpdates := make(map[string]interface{})
	rentalInfoUpdates := make(map[string]interface{})
	statusUpdates := make(map[string]interface{})

	// Basic car details
	if req.Make != nil {
		carUpdates["make"] = *req.Make
	}
	if req.Model != nil {
		carUpdates["model"] = *req.Model
	}
	if req.Year != nil {
		carUpdates["year"] = *req.Year
	}
	if req.Variant != nil {
		carUpdates["variant"] = *req.Variant
	}
	if req.FuelType != nil {
		carUpdates["fuel_type"] = *req.FuelType
	}
	if req.Transmission != nil {
		carUpdates["transmission"] = *req.Transmission
	}
	if req.BodyType != nil {
		carUpdates["body_type"] = *req.BodyType
	}
	if req.Color != nil {
		carUpdates["color"] = *req.Color
	}
	if req.SeatingCapacity != nil {
		carUpdates["seating_capacity"] = *req.SeatingCapacity
	}
	if req.VehicleNumber != nil {
		carUpdates["vehicle_number"] = *req.VehicleNumber
	}

	// Rental info
	if req.RentalInfo != nil {
		if req.RentalInfo.RentalPricePerDay != nil {
			rentalInfoUpdates["rental_price_per_day"] = *req.RentalInfo.RentalPricePerDay
		}
		if req.RentalInfo.RentalPricePerHour != nil {
			rentalInfoUpdates["rental_price_per_hour"] = *req.RentalInfo.RentalPricePerHour
		}
		if req.RentalInfo.MinimumRentDuration != nil {
			rentalInfoUpdates["minimum_rent_duration"] = *req.RentalInfo.MinimumRentDuration
		}
		if req.RentalInfo.SecurityDeposit != nil {
			rentalInfoUpdates["security_deposit"] = *req.RentalInfo.SecurityDeposit
		}
		if req.RentalInfo.LateFeePerHour != nil {
			rentalInfoUpdates["late_fee_per_hour"] = *req.RentalInfo.LateFeePerHour
		}
		if req.RentalInfo.RentalExtendFeePerDay != nil {
			rentalInfoUpdates["rental_extend_fee_per_day"] = *req.RentalInfo.RentalExtendFeePerDay
		}
		if req.RentalInfo.RentalExtendFeePerHour != nil {
			rentalInfoUpdates["rental_extend_fee_per_hour"] = *req.RentalInfo.RentalExtendFeePerHour
		}
	}

	// Media handling
	if req.Media != nil {
		// Add new images
		if len(req.Media.AddImages) > 0 {
			for _, imageURL := range req.Media.AddImages {
				err := carService.AddCarMedia(carID, "image", imageURL, false)
				if err != nil {
					return utils.ServerErrorResponse(c, "Failed to add image: "+err.Error())
				}
			}
		}

		// Remove images
		if len(req.Media.RemoveImages) > 0 {
			for _, imageURL := range req.Media.RemoveImages {
				// Find the media ID from the URL
				for _, media := range existingCar.Media {
					if media.URL == imageURL && media.Type == "image" {
						err := carService.RemoveCarMedia(media.ID)
						if err != nil {
							return utils.ServerErrorResponse(c, "Failed to remove image: "+err.Error())
						}
						break
					}
				}
			}
		}

		// Update video
		if req.Media.Video != nil {
			// Check if car already has a video
			for _, media := range existingCar.Media {
				if media.Type == "video" {
					// Update existing video
					err := carService.RemoveCarMedia(media.ID)
					if err != nil {
						return utils.ServerErrorResponse(c, "Failed to remove old video: "+err.Error())
					}
					break
				}
			}

			// Add new video
			err := carService.AddCarMedia(carID, "video", *req.Media.Video, false)
			if err != nil {
				return utils.ServerErrorResponse(c, "Failed to add video: "+err.Error())
			}
		}
	}

	// Status info
	if req.Status != nil {
		if req.Status.IsAvailable != nil {
			statusUpdates["is_available"] = *req.Status.IsAvailable
		}
		if req.Status.CurrentOdometerReading != nil {
			statusUpdates["current_odometer_reading"] = *req.Status.CurrentOdometerReading
		}
		if req.Status.DamagesOrIssues != nil {
			statusUpdates["damages_or_issues"] = *req.Status.DamagesOrIssues
		}
	}

	// Owner info
	if req.Owner != nil && req.Owner.OwnerID != nil {
		carUpdates["owner_id"] = *req.Owner.OwnerID
	}

	// Update the car and related entities
	updatedCar, err := carService.UpdateCar(carID, carUpdates, rentalInfoUpdates, statusUpdates)
	if err != nil {
		return utils.ServerErrorResponse(c, "Failed to update car: "+err.Error())
	}

	// Convert to response format
	response := updatedCar.ToCarResponse()

	return utils.SuccessResponse(c, response, "Car updated successfully")
}

func DeleteCar(c *fiber.Ctx) error {
	id := c.Params("id")
	carID, err := uuid.Parse(id)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid car ID", []string{"Invalid UUID format"})
	}

	carService := services.NewCarService()
	err = carService.DeleteCar(carID)
	if err != nil {
		return utils.ServerErrorResponse(c, "Failed to delete car: "+err.Error())
	}

	return utils.SuccessResponse(c, nil, "Car deleted successfully")
}

func GetAvailableCars(c *fiber.Ctx) error {
	// Get pagination parameters from request
	page, pageSize := utils.GetPaginationParams(c)

	startTime := c.Query("start")
	endTime := c.Query("end")

	// Get filter parameters (same as GetCars)
	filters := map[string]interface{}{
		"make":         utils.GetStringParam(c, "make"),
		"model":        utils.GetStringParam(c, "model"),
		"year":         utils.GetIntParam(c, "year", 0),
		"min_year":     utils.GetIntParam(c, "min_year", 0),
		"max_year":     utils.GetIntParam(c, "max_year", 0),
		"fuel_type":    utils.GetStringParam(c, "fuel_type"),
		"transmission": utils.GetStringParam(c, "transmission"),
		"body_type":    utils.GetStringParam(c, "body_type"),
	}

	carService := services.NewCarService()

	if startTime == "" || endTime == "" {
		// Add the isAvailable filter
		filters["is_available"] = true

		// Get paginated cars with filters
		cars, totalItems, err := carService.GetAllCarsPaginated(page, pageSize, filters)
		if err != nil {
			return utils.ServerErrorResponse(c, "Failed to fetch available cars: "+err.Error())
		}

		// Create pagination metadata
		pagination := models.NewPagination(totalItems, page, pageSize)

		// Convert cars to response format
		var responses []models.CarResponse
		for _, car := range cars {
			responses = append(responses, car.ToCarResponse())
		}

		return utils.PaginatedSuccessResponse(c, responses, pagination, "Available cars fetched successfully")
	}

	// Parse time range for booking availability check
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

	// Add isAvailable filter and load bookings for time range check
	filters["is_available"] = true
	filters["load_bookings"] = true

	// Get available cars with filtering and pagination
	cars, _, err := carService.GetAllCarsPaginated(page, pageSize, filters)
	if err != nil {
		return utils.ServerErrorResponse(c, "Failed to fetch available cars: "+err.Error())
	}

	// Filter out cars that have bookings in the requested time range
	var availableCars []models.Car
	for _, car := range cars {
		carIsAvailable := true
		for _, booking := range car.Bookings {
			// Check if booking overlaps with requested time range
			if booking.Status == models.BookingStatusBooked &&
				!(booking.EndTime.Before(start) || booking.StartTime.After(end)) {
				carIsAvailable = false
				break
			}
		}
		if carIsAvailable {
			availableCars = append(availableCars, car)
		}
	}

	// Adjust total items count after filtering
	filteredTotalItems := int64(len(availableCars))

	// Create pagination metadata based on filtered results
	pagination := models.NewPagination(filteredTotalItems, page, pageSize)

	// Convert cars to response format
	var responses []models.CarResponse
	for _, car := range availableCars {
		responses = append(responses, car.ToCarResponse())
	}

	return utils.PaginatedSuccessResponse(c, responses, pagination, "Available cars fetched successfully")
}
