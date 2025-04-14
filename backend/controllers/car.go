package controllers

import (
	"car-rental-backend/database"
	"car-rental-backend/models"
	"car-rental-backend/utils"
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
		InsuranceExpiryDate     time.Time `json:"insurance_expiry_date" validate:"required"`
		PollutionCertValidity   time.Time `json:"pollution_certificate_validity" validate:"required"`
		RegistrationCertificate string    `json:"registration_certificate" validate:"required"`
		FitnessCertificate      string    `json:"fitness_certificate" validate:"required"`
		PermitType              string    `json:"permit_type" validate:"required,oneof=Self-drive Commercial"`
	} `json:"documentation" validate:"required"`

	// Status Info
	Status struct {
		IsAvailable            bool      `json:"is_available"`
		CurrentOdometerReading float64   `json:"current_odometer_reading" validate:"required,min=0"`
		LastServiceDate        time.Time `json:"last_service_date" validate:"required"`
		NextServiceDue         time.Time `json:"next_service_due" validate:"required"`
		DamagesOrIssues        *string   `json:"damages_or_issues,omitempty"`
	} `json:"status" validate:"required"`

	// Owner Info
	Owner struct {
		OwnerID     uuid.UUID `json:"owner_id" validate:"required"`
		OwnerName   string    `json:"owner_name" validate:"required"`
		ContactInfo string    `json:"contact_info" validate:"required"`
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
		Images []string `json:"images,omitempty"`
		Video  *string  `json:"video,omitempty"`
	} `json:"media,omitempty"`

	// Documentation
	Documentation *struct {
		InsuranceExpiryDate     *time.Time `json:"insurance_expiry_date,omitempty"`
		PollutionCertValidity   *time.Time `json:"pollution_certificate_validity,omitempty"`
		RegistrationCertificate *string    `json:"registration_certificate,omitempty"`
		FitnessCertificate      *string    `json:"fitness_certificate,omitempty"`
		PermitType              *string    `json:"permit_type,omitempty"`
	} `json:"documentation,omitempty"`

	// Status Info
	Status *struct {
		IsAvailable            *bool      `json:"is_available,omitempty"`
		CurrentOdometerReading *float64   `json:"current_odometer_reading,omitempty"`
		LastServiceDate        *time.Time `json:"last_service_date,omitempty"`
		NextServiceDue         *time.Time `json:"next_service_due,omitempty"`
		DamagesOrIssues        *string    `json:"damages_or_issues,omitempty"`
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

	// Validate owner exists
	var owner models.User
	if result := database.DB.First(&owner, "id = ?", req.Owner.OwnerID); result.Error != nil {
		return utils.ValidationErrorResponse(c, "Invalid owner", []string{
			"Owner with ID " + req.Owner.OwnerID.String() + " does not exist",
		})
	}

	// Check if vehicle number already exists
	var existingCar models.Car
	if result := database.DB.Where("vehicle_number = ?", req.VehicleNumber).First(&existingCar); result.Error == nil {
		return utils.ConflictResponse(c, "Vehicle number already exists")
	}

	car := models.Car{
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
		Location: models.CarLocation{
			CurrentLocation:   req.Location.CurrentLocation,
			AvailableBranches: req.Location.AvailableBranches,
		},
		RentalInfo: models.CarRentalInfo{
			RentalPricePerDay:   req.RentalInfo.RentalPricePerDay,
			RentalPricePerHour:  req.RentalInfo.RentalPricePerHour,
			MinimumRentDuration: req.RentalInfo.MinimumRentDuration,
			MaximumRentDuration: req.RentalInfo.MaximumRentDuration,
			SecurityDeposit:     req.RentalInfo.SecurityDeposit,
			LateFeePerHour:      req.RentalInfo.LateFeePerHour,
			Discounts:           req.RentalInfo.Discounts,
		},
		Media: models.CarMedia{
			Images: req.Media.Images,
			Video:  req.Media.Video,
		},
		Documentation: models.CarDocumentation{
			InsuranceExpiryDate:     req.Documentation.InsuranceExpiryDate,
			PollutionCertValidity:   req.Documentation.PollutionCertValidity,
			RegistrationCertificate: req.Documentation.RegistrationCertificate,
			FitnessCertificate:      req.Documentation.FitnessCertificate,
			PermitType:              models.PermitType(req.Documentation.PermitType),
		},
		Status: models.CarStatus{
			IsAvailable:            req.Status.IsAvailable,
			CurrentOdometerReading: req.Status.CurrentOdometerReading,
			LastServiceDate:        req.Status.LastServiceDate,
			NextServiceDue:         req.Status.NextServiceDue,
			DamagesOrIssues:        req.Status.DamagesOrIssues,
		},
		Owner: models.OwnerInfo{
			OwnerID:     req.Owner.OwnerID,
			OwnerName:   req.Owner.OwnerName,
			ContactInfo: req.Owner.ContactInfo,
		},
	}

	if result := database.DB.Create(&car); result.Error != nil {
		return utils.ServerErrorResponse(c, "Failed to create car: "+result.Error.Error())
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

	// Update basic car details
	if req.Make != nil {
		car.Make = *req.Make
	}
	if req.Model != nil {
		car.Model = *req.Model
	}
	if req.Year != nil {
		car.Year = *req.Year
	}
	if req.Variant != nil {
		car.Variant = *req.Variant
	}
	if req.FuelType != nil {
		car.FuelType = models.FuelType(*req.FuelType)
	}
	if req.Transmission != nil {
		car.Transmission = models.TransmissionType(*req.Transmission)
	}
	if req.BodyType != nil {
		car.BodyType = models.BodyType(*req.BodyType)
	}
	if req.Color != nil {
		car.Color = *req.Color
	}
	if req.SeatingCapacity != nil {
		car.SeatingCapacity = *req.SeatingCapacity
	}
	if req.VehicleNumber != nil {
		car.VehicleNumber = *req.VehicleNumber
	}
	if req.RegistrationState != nil {
		car.RegistrationState = *req.RegistrationState
	}

	// Update location
	if req.Location != nil {
		if req.Location.CurrentLocation != nil {
			car.Location.CurrentLocation = *req.Location.CurrentLocation
		}
		if req.Location.AvailableBranches != nil {
			car.Location.AvailableBranches = req.Location.AvailableBranches
		}
	}

	// Update rental info
	if req.RentalInfo != nil {
		if req.RentalInfo.RentalPricePerDay != nil {
			car.RentalInfo.RentalPricePerDay = *req.RentalInfo.RentalPricePerDay
		}
		if req.RentalInfo.RentalPricePerHour != nil {
			car.RentalInfo.RentalPricePerHour = req.RentalInfo.RentalPricePerHour
		}
		if req.RentalInfo.MinimumRentDuration != nil {
			car.RentalInfo.MinimumRentDuration = *req.RentalInfo.MinimumRentDuration
		}
		if req.RentalInfo.MaximumRentDuration != nil {
			car.RentalInfo.MaximumRentDuration = *req.RentalInfo.MaximumRentDuration
		}
		if req.RentalInfo.SecurityDeposit != nil {
			car.RentalInfo.SecurityDeposit = *req.RentalInfo.SecurityDeposit
		}
		if req.RentalInfo.LateFeePerHour != nil {
			car.RentalInfo.LateFeePerHour = *req.RentalInfo.LateFeePerHour
		}
		if req.RentalInfo.Discounts != nil {
			car.RentalInfo.Discounts = req.RentalInfo.Discounts
		}
	}

	// Update media
	if req.Media != nil {
		if req.Media.Images != nil {
			car.Media.Images = req.Media.Images
		}
		if req.Media.Video != nil {
			car.Media.Video = req.Media.Video
		}
	}

	// Update documentation
	if req.Documentation != nil {
		if req.Documentation.InsuranceExpiryDate != nil {
			car.Documentation.InsuranceExpiryDate = *req.Documentation.InsuranceExpiryDate
		}
		if req.Documentation.PollutionCertValidity != nil {
			car.Documentation.PollutionCertValidity = *req.Documentation.PollutionCertValidity
		}
		if req.Documentation.RegistrationCertificate != nil {
			car.Documentation.RegistrationCertificate = *req.Documentation.RegistrationCertificate
		}
		if req.Documentation.FitnessCertificate != nil {
			car.Documentation.FitnessCertificate = *req.Documentation.FitnessCertificate
		}
		if req.Documentation.PermitType != nil {
			car.Documentation.PermitType = models.PermitType(*req.Documentation.PermitType)
		}
	}

	// Update status
	if req.Status != nil {
		if req.Status.IsAvailable != nil {
			car.Status.IsAvailable = *req.Status.IsAvailable
		}
		if req.Status.CurrentOdometerReading != nil {
			car.Status.CurrentOdometerReading = *req.Status.CurrentOdometerReading
		}
		if req.Status.LastServiceDate != nil {
			car.Status.LastServiceDate = *req.Status.LastServiceDate
		}
		if req.Status.NextServiceDue != nil {
			car.Status.NextServiceDue = *req.Status.NextServiceDue
		}
		if req.Status.DamagesOrIssues != nil {
			car.Status.DamagesOrIssues = req.Status.DamagesOrIssues
		}
	}

	// Update owner info
	if req.Owner != nil {
		if req.Owner.OwnerID != nil {
			car.Owner.OwnerID = *req.Owner.OwnerID
		}
		if req.Owner.OwnerName != nil {
			car.Owner.OwnerName = *req.Owner.OwnerName
		}
		if req.Owner.ContactInfo != nil {
			car.Owner.ContactInfo = *req.Owner.ContactInfo
		}
	}

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
	query := database.DB.Where("status->>'is_available' = ?", "true").
		Where("id NOT IN (SELECT car_id FROM bookings WHERE status = ? AND start_time < ? AND end_time > ?)",
			models.BookingStatusBooked, end, start)

	if result := query.Find(&cars); result.Error != nil {
		return utils.ServerErrorResponse(c, "Failed to fetch available cars")
	}

	return utils.SuccessResponse(c, cars, "Available cars fetched successfully")
}
