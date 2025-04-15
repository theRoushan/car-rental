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
	Make              string `json:"make" validate:"required"`
	Model             string `json:"model" validate:"required"`
	Year              int    `json:"year" validate:"required,min=1900,max=2024"`
	Variant           string `json:"variant" validate:"required"`
	FuelType          string `json:"fuel_type" validate:"required,oneof=Petrol Diesel Electric Hybrid"`
	Transmission      string `json:"transmission" validate:"required,oneof=Manual Automatic CVT"`
	BodyType          string `json:"body_type" validate:"required,oneof=Sedan SUV Hatchback Coupe Van Truck"`
	Color             string `json:"color" validate:"required"`
	SeatingCapacity   int    `json:"seating_capacity" validate:"required,min=1,max=50"`
	VehicleNumber     string `json:"vehicle_number" validate:"required"`
	RegistrationState string `json:"registration_state" validate:"required"`

	// Location Info
	Location struct {
		CurrentLocation   string   `json:"current_location" validate:"required"`
		AvailableBranches []string `json:"available_branches" validate:"required,min=1"`
	} `json:"location" validate:"required"`

	// Rental Info
	RentalInfo struct {
		RentalPricePerDay   float64  `json:"rental_price_per_day" validate:"required,min=0"`
		RentalPricePerHour  *float64 `json:"rental_price_per_hour,omitempty"`
		MinimumRentDuration int      `json:"minimum_rent_duration" validate:"required,min=1"`
		MaximumRentDuration int      `json:"maximum_rent_duration" validate:"required,min=1"`
		SecurityDeposit     float64  `json:"security_deposit" validate:"required,min=0"`
		LateFeePerHour      float64  `json:"late_fee_per_hour" validate:"required,min=0"`
		Discounts           *string  `json:"discounts,omitempty"`
	} `json:"rental_info" validate:"required"`

	// Media
	Media struct {
		Images []string `json:"images" validate:"required,min=1"`
		Video  *string  `json:"video,omitempty"`
	} `json:"media" validate:"required"`

	// Documentation
	Documentation struct {
		InsuranceExpiryDate     string `json:"insurance_expiry_date" validate:"required"`
		PollutionCertValidity   string `json:"pollution_certificate_validity" validate:"required"`
		RegistrationCertificate string `json:"registration_certificate" validate:"required"`
		FitnessCertificate      string `json:"fitness_certificate" validate:"required"`
		PermitType              string `json:"permit_type" validate:"required,oneof=Self-drive Commercial"`
	} `json:"documentation" validate:"required"`

	// Status Info
	Status struct {
		IsAvailable            bool    `json:"is_available"`
		CurrentOdometerReading float64 `json:"current_odometer_reading" validate:"required,min=0"`
		LastServiceDate        string  `json:"last_service_date" validate:"required"`
		NextServiceDue         string  `json:"next_service_due" validate:"required"`
		DamagesOrIssues        *string `json:"damages_or_issues,omitempty"`
	} `json:"status" validate:"required"`

	// Owner Info
	Owner struct {
		OwnerID uuid.UUID `json:"owner_id" validate:"required"`
	} `json:"owner" validate:"required"`
}

// UpdateCarRequest represents the request body for updating a car
type UpdateCarRequest struct {
	// Basic Car Details
	Make              *string `json:"make,omitempty"`
	Model             *string `json:"model,omitempty"`
	Year              *int    `json:"year,omitempty"`
	Variant           *string `json:"variant,omitempty"`
	FuelType          *string `json:"fuel_type,omitempty"`
	Transmission      *string `json:"transmission,omitempty"`
	BodyType          *string `json:"body_type,omitempty"`
	Color             *string `json:"color,omitempty"`
	SeatingCapacity   *int    `json:"seating_capacity,omitempty"`
	VehicleNumber     *string `json:"vehicle_number,omitempty"`
	RegistrationState *string `json:"registration_state,omitempty"`

	// Location Info
	Location *struct {
		CurrentLocation   *string  `json:"current_location,omitempty"`
		AvailableBranches []string `json:"available_branches,omitempty"`
	} `json:"location,omitempty"`

	// Rental Info
	RentalInfo *struct {
		RentalPricePerDay   *float64 `json:"rental_price_per_day,omitempty"`
		RentalPricePerHour  *float64 `json:"rental_price_per_hour,omitempty"`
		MinimumRentDuration *int     `json:"minimum_rent_duration,omitempty"`
		MaximumRentDuration *int     `json:"maximum_rent_duration,omitempty"`
		SecurityDeposit     *float64 `json:"security_deposit,omitempty"`
		LateFeePerHour      *float64 `json:"late_fee_per_hour,omitempty"`
		Discounts           *string  `json:"discounts,omitempty"`
	} `json:"rental_info,omitempty"`

	// Media
	Media *struct {
		AddImages    []string `json:"add_images,omitempty"`
		RemoveImages []string `json:"remove_images,omitempty"`
		Video        *string  `json:"video,omitempty"`
	} `json:"media,omitempty"`

	// Documentation
	Documentation *struct {
		InsuranceExpiryDate     *string `json:"insurance_expiry_date,omitempty"`
		PollutionCertValidity   *string `json:"pollution_certificate_validity,omitempty"`
		RegistrationCertificate *string `json:"registration_certificate,omitempty"`
		FitnessCertificate      *string `json:"fitness_certificate,omitempty"`
		PermitType              *string `json:"permit_type,omitempty"`
	} `json:"documentation,omitempty"`

	// Status Info
	Status *struct {
		IsAvailable            *bool    `json:"is_available,omitempty"`
		CurrentOdometerReading *float64 `json:"current_odometer_reading,omitempty"`
		LastServiceDate        *string  `json:"last_service_date,omitempty"`
		NextServiceDue         *string  `json:"next_service_due,omitempty"`
		DamagesOrIssues        *string  `json:"damages_or_issues,omitempty"`
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

	// Parse date strings
	insuranceExpiryDate, err := time.Parse("2006-01-02", req.Documentation.InsuranceExpiryDate)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid date format", []string{
			"Invalid insurance expiry date. Format should be YYYY-MM-DD",
		})
	}

	pollutionCertValidity, err := time.Parse("2006-01-02", req.Documentation.PollutionCertValidity)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid date format", []string{
			"Invalid pollution certificate validity. Format should be YYYY-MM-DD",
		})
	}

	lastServiceDate, err := time.Parse("2006-01-02", req.Status.LastServiceDate)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid date format", []string{
			"Invalid last service date. Format should be YYYY-MM-DD",
		})
	}

	nextServiceDue, err := time.Parse("2006-01-02", req.Status.NextServiceDue)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid date format", []string{
			"Invalid next service due date. Format should be YYYY-MM-DD",
		})
	}

	// Validate date logic
	now := time.Now()
	if insuranceExpiryDate.Before(now) {
		return utils.ValidationErrorResponse(c, "Invalid expiry date", []string{
			"Insurance expiry date cannot be in the past",
		})
	}

	if pollutionCertValidity.Before(now) {
		return utils.ValidationErrorResponse(c, "Invalid expiry date", []string{
			"Pollution certificate validity cannot be in the past",
		})
	}

	if nextServiceDue.Before(lastServiceDate) {
		return utils.ValidationErrorResponse(c, "Invalid service dates", []string{
			"Next service due date must be after last service date",
		})
	}

	// Create the car with basic details
	car := &models.Car{
		Make:              req.Make,
		Model:             req.Model,
		Year:              req.Year,
		Variant:           req.Variant,
		FuelType:          models.FuelType(req.FuelType),
		Transmission:      models.TransmissionType(req.Transmission),
		BodyType:          models.BodyType(req.BodyType),
		Color:             req.Color,
		SeatingCapacity:   req.SeatingCapacity,
		VehicleNumber:     req.VehicleNumber,
		RegistrationState: req.RegistrationState,
		OwnerID:           req.Owner.OwnerID,
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

	// Validate location
	if len(req.Location.AvailableBranches) == 0 {
		return utils.ValidationErrorResponse(c, "Invalid location", []string{
			"At least one available branch must be specified",
		})
	}
	location := &models.CarLocation{
		CurrentLocation:   req.Location.CurrentLocation,
		AvailableBranches: req.Location.AvailableBranches,
	}

	// Validate rental info
	if req.RentalInfo.MaximumRentDuration < req.RentalInfo.MinimumRentDuration {
		return utils.ValidationErrorResponse(c, "Invalid rental duration", []string{
			"Maximum rent duration must be greater than or equal to minimum rent duration",
		})
	}
	rentalInfo := &models.CarRentalInfo{
		RentalPricePerDay:   req.RentalInfo.RentalPricePerDay,
		RentalPricePerHour:  req.RentalInfo.RentalPricePerHour,
		MinimumRentDuration: req.RentalInfo.MinimumRentDuration,
		MaximumRentDuration: req.RentalInfo.MaximumRentDuration,
		SecurityDeposit:     req.RentalInfo.SecurityDeposit,
		LateFeePerHour:      req.RentalInfo.LateFeePerHour,
		Discounts:           req.RentalInfo.Discounts,
	}

	status := &models.CarStatus{
		IsAvailable:            req.Status.IsAvailable,
		CurrentOdometerReading: req.Status.CurrentOdometerReading,
		LastServiceDate:        lastServiceDate,
		NextServiceDue:         nextServiceDue,
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

	// Create document entries
	insuranceDoc := models.CarDocument{
		DocumentType: "insurance",
		ExpiryDate:   &insuranceExpiryDate,
		DocumentPath: "insurance_cert_" + req.VehicleNumber,
		PermitType:   models.PermitType(req.Documentation.PermitType),
	}

	pollutionDoc := models.CarDocument{
		DocumentType: "pollution",
		ExpiryDate:   &pollutionCertValidity,
		DocumentPath: req.Documentation.PollutionCertValidity,
		PermitType:   models.PermitType(req.Documentation.PermitType),
	}

	registrationDoc := models.CarDocument{
		DocumentType: "registration",
		DocumentPath: req.Documentation.RegistrationCertificate,
		PermitType:   models.PermitType(req.Documentation.PermitType),
	}

	fitnessDoc := models.CarDocument{
		DocumentType: "fitness",
		DocumentPath: req.Documentation.FitnessCertificate,
		PermitType:   models.PermitType(req.Documentation.PermitType),
	}

	documents := []models.CarDocument{
		insuranceDoc,
		pollutionDoc,
		registrationDoc,
		fitnessDoc,
	}

	// Create the car with all related entities in a transaction
	// Notice we're not passing owner anymore as we already have owner_id in car struct
	createdCar, err := carService.CreateCarWithOwnerID(car, req.Owner.OwnerID, location, rentalInfo, mediaEntries, documents, status)
	if err != nil {
		// Use the database error handler for better error responses
		return utils.HandleDatabaseError(c, err)
	}

	// Convert to response format
	response := createdCar.ToCarResponse()

	return utils.SuccessResponse(c, response, "Car created successfully")
}

func GetCars(c *fiber.Ctx) error {
	carService := services.NewCarService()

	cars, err := carService.GetAllCars()
	if err != nil {
		return utils.ServerErrorResponse(c, "Failed to fetch cars: "+err.Error())
	}

	// Convert cars to response format
	var responses []models.CarResponse
	for _, car := range cars {
		responses = append(responses, car.ToCarResponse())
	}

	return utils.SuccessResponse(c, responses, "Cars fetched successfully")
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
	locationUpdates := make(map[string]interface{})
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
	if req.RegistrationState != nil {
		carUpdates["registration_state"] = *req.RegistrationState
	}

	// Location info
	if req.Location != nil {
		if req.Location.CurrentLocation != nil {
			locationUpdates["current_location"] = *req.Location.CurrentLocation
		}
		if len(req.Location.AvailableBranches) > 0 {
			locationUpdates["available_branches"] = req.Location.AvailableBranches
		}
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
		if req.RentalInfo.MaximumRentDuration != nil {
			rentalInfoUpdates["maximum_rent_duration"] = *req.RentalInfo.MaximumRentDuration
		}
		if req.RentalInfo.SecurityDeposit != nil {
			rentalInfoUpdates["security_deposit"] = *req.RentalInfo.SecurityDeposit
		}
		if req.RentalInfo.LateFeePerHour != nil {
			rentalInfoUpdates["late_fee_per_hour"] = *req.RentalInfo.LateFeePerHour
		}
		if req.RentalInfo.Discounts != nil {
			rentalInfoUpdates["discounts"] = *req.RentalInfo.Discounts
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

	// Documentation updates
	if req.Documentation != nil {
		// Update document expiry dates and paths as needed
		for _, doc := range existingCar.Documents {
			if req.Documentation.InsuranceExpiryDate != nil && doc.DocumentType == "insurance" {
				// Parse the date
				expiryDate, err := time.Parse("2006-01-02", *req.Documentation.InsuranceExpiryDate)
				if err != nil {
					return utils.ValidationErrorResponse(c, "Invalid date format", []string{
						"Invalid insurance expiry date. Format should be YYYY-MM-DD",
					})
				}
				err = carService.UpdateDocumentExpiry(doc.ID, expiryDate)
				if err != nil {
					return utils.ServerErrorResponse(c, "Failed to update insurance expiry: "+err.Error())
				}
			}

			if req.Documentation.PollutionCertValidity != nil && doc.DocumentType == "pollution" {
				// Parse the date
				expiryDate, err := time.Parse("2006-01-02", *req.Documentation.PollutionCertValidity)
				if err != nil {
					return utils.ValidationErrorResponse(c, "Invalid date format", []string{
						"Invalid pollution certificate validity. Format should be YYYY-MM-DD",
					})
				}
				err = carService.UpdateDocumentExpiry(doc.ID, expiryDate)
				if err != nil {
					return utils.ServerErrorResponse(c, "Failed to update pollution certificate validity: "+err.Error())
				}
			}

			// You can handle other document updates similarly
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
		if req.Status.LastServiceDate != nil {
			// Parse the date
			lastServiceDate, err := time.Parse("2006-01-02", *req.Status.LastServiceDate)
			if err != nil {
				return utils.ValidationErrorResponse(c, "Invalid date format", []string{
					"Invalid last service date. Format should be YYYY-MM-DD",
				})
			}
			statusUpdates["last_service_date"] = lastServiceDate
		}
		if req.Status.NextServiceDue != nil {
			// Parse the date
			nextServiceDue, err := time.Parse("2006-01-02", *req.Status.NextServiceDue)
			if err != nil {
				return utils.ValidationErrorResponse(c, "Invalid date format", []string{
					"Invalid next service due date. Format should be YYYY-MM-DD",
				})
			}
			statusUpdates["next_service_due"] = nextServiceDue
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
	updatedCar, err := carService.UpdateCar(carID, carUpdates, locationUpdates, rentalInfoUpdates, statusUpdates)
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
	startTime := c.Query("start")
	endTime := c.Query("end")

	if startTime == "" || endTime == "" {
		// If no time range specified, just get all available cars
		carService := services.NewCarService()
		availableCars, err := carService.GetAvailableCars()
		if err != nil {
			return utils.ServerErrorResponse(c, "Failed to fetch available cars: "+err.Error())
		}

		// Convert to response format
		var responses []models.CarResponse
		for _, car := range availableCars {
			responses = append(responses, car.ToCarResponse())
		}

		return utils.SuccessResponse(c, responses, "Available cars fetched successfully")
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

	// Use a custom query to find cars available for booking in the specified time range
	carService := services.NewCarService()
	isAvailable := true
	cars, err := carService.SearchCars("", "", "", &isAvailable, nil, nil)
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

	// Convert to response format
	var responses []models.CarResponse
	for _, car := range availableCars {
		responses = append(responses, car.ToCarResponse())
	}

	return utils.SuccessResponse(c, responses, "Available cars fetched successfully")
}
