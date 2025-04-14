package models

import (
	"time"

	"github.com/google/uuid"
)

// Enums
type FuelType string
type TransmissionType string
type BodyType string
type PermitType string

const (
	FuelTypePetrol   FuelType = "Petrol"
	FuelTypeDiesel   FuelType = "Diesel"
	FuelTypeElectric FuelType = "Electric"
	FuelTypeHybrid   FuelType = "Hybrid"

	TransmissionManual    TransmissionType = "Manual"
	TransmissionAutomatic TransmissionType = "Automatic"
	TransmissionCVT       TransmissionType = "CVT"

	BodyTypeSedan     BodyType = "Sedan"
	BodyTypeSUV       BodyType = "SUV"
	BodyTypeHatchback BodyType = "Hatchback"
	BodyTypeCoupe     BodyType = "Coupe"
	BodyTypeVan       BodyType = "Van"
	BodyTypeTruck     BodyType = "Truck"

	PermitTypeSelfDrive  PermitType = "Self-drive"
	PermitTypeCommercial PermitType = "Commercial"
)

// CarLocation represents the location information of a car
type CarLocation struct {
	Base
	CarID             uuid.UUID `json:"-" gorm:"index"`
	CurrentLocation   string    `json:"current_location"`
	AvailableBranches []string  `json:"available_branches" gorm:"type:jsonb"`
}

// CarRentalInfo represents the rental-related information
type CarRentalInfo struct {
	Base
	CarID               uuid.UUID `json:"-" gorm:"index"`
	RentalPricePerDay   float64   `json:"rental_price_per_day"`
	RentalPricePerHour  *float64  `json:"rental_price_per_hour,omitempty"`
	MinimumRentDuration int       `json:"minimum_rent_duration"` // in hours
	MaximumRentDuration int       `json:"maximum_rent_duration"` // in hours
	SecurityDeposit     float64   `json:"security_deposit"`
	LateFeePerHour      float64   `json:"late_fee_per_hour"`
	Discounts           *string   `json:"discounts,omitempty" gorm:"type:jsonb"`
}

// CarMedia represents the media assets of a car
type CarMedia struct {
	Base
	CarID     uuid.UUID `json:"-" gorm:"index"`
	Type      string    `json:"type"`
	URL       string    `json:"url"`
	IsPrimary bool      `json:"is_primary" gorm:"default:false"`
}

// CarDocument represents a document related to a car
type CarDocument struct {
	Base
	CarID        uuid.UUID  `json:"-" gorm:"index"`
	DocumentType string     `json:"document_type"`
	ExpiryDate   *time.Time `json:"expiry_date,omitempty"`
	DocumentPath string     `json:"document_path"`
	PermitType   PermitType `json:"permit_type,omitempty"`
}

// CarStatus represents the current status and maintenance information
type CarStatus struct {
	Base
	CarID                  uuid.UUID `json:"-" gorm:"index"`
	IsAvailable            bool      `json:"is_available" gorm:"default:true"`
	CurrentOdometerReading float64   `json:"current_odometer_reading"`
	LastServiceDate        time.Time `json:"last_service_date"`
	NextServiceDue         time.Time `json:"next_service_due"`
	DamagesOrIssues        *string   `json:"damages_or_issues,omitempty"`
}

// Owner represents a car owner entity
type Owner struct {
	Base
	Name        string `json:"name"`
	ContactInfo string `json:"contact_info"`
	Cars        []Car  `json:"cars,omitempty" gorm:"foreignKey:OwnerID"`
}

// Car represents the main car entity with all its details
type Car struct {
	Base

	// Basic Car Details
	Make              string           `json:"make"`
	Model             string           `json:"model"`
	Year              int              `json:"year"`
	Variant           string           `json:"variant"`
	FuelType          FuelType         `json:"fuel_type" gorm:"type:varchar(20);not null"`
	Transmission      TransmissionType `json:"transmission" gorm:"type:varchar(20);not null"`
	BodyType          BodyType         `json:"body_type" gorm:"type:varchar(20);not null"`
	Color             string           `json:"color"`
	SeatingCapacity   int              `json:"seating_capacity"`
	VehicleNumber     string           `json:"vehicle_number" gorm:"uniqueIndex"`
	RegistrationState string           `json:"registration_state"`

	// Relationships
	OwnerID       uuid.UUID      `json:"owner_id" gorm:"index"`
	Owner         Owner          `json:"owner,omitempty" gorm:"foreignKey:OwnerID"`
	Location      *CarLocation   `json:"location,omitempty" gorm:"foreignKey:CarID"`
	RentalInfo    *CarRentalInfo `json:"rental_info,omitempty" gorm:"foreignKey:CarID"`
	Media         []CarMedia     `json:"media,omitempty" gorm:"foreignKey:CarID"`
	Documents     []CarDocument  `json:"documents,omitempty" gorm:"foreignKey:CarID"`
	CurrentStatus *CarStatus     `json:"status,omitempty" gorm:"foreignKey:CarID"`
	Bookings      []Booking      `json:"bookings,omitempty" gorm:"foreignKey:CarID"`
}

// CarResponse represents the API response structure for a car
type CarResponse struct {
	ID                string           `json:"id"`
	Make              string           `json:"make"`
	Model             string           `json:"model"`
	Year              int              `json:"year"`
	Variant           string           `json:"variant"`
	FuelType          FuelType         `json:"fuel_type"`
	Transmission      TransmissionType `json:"transmission"`
	BodyType          BodyType         `json:"body_type"`
	Color             string           `json:"color"`
	SeatingCapacity   int              `json:"seating_capacity"`
	VehicleNumber     string           `json:"vehicle_number"`
	RegistrationState string           `json:"registration_state"`

	// Owner Info
	OwnerID      string `json:"owner_id"`
	OwnerName    string `json:"owner_name,omitempty"`
	OwnerContact string `json:"owner_contact,omitempty"`

	// Location, displayed from the embedded struct for backward compatibility
	CurrentLocation   string   `json:"current_location,omitempty"`
	AvailableBranches []string `json:"available_branches,omitempty"`

	// Rental Info for backward compatibility
	RentalPricePerDay   float64  `json:"rental_price_per_day,omitempty"`
	RentalPricePerHour  *float64 `json:"rental_price_per_hour,omitempty"`
	MinimumRentDuration int      `json:"minimum_rent_duration,omitempty"`
	MaximumRentDuration int      `json:"maximum_rent_duration,omitempty"`
	SecurityDeposit     float64  `json:"security_deposit,omitempty"`
	LateFeePerHour      float64  `json:"late_fee_per_hour,omitempty"`
	Discounts           *string  `json:"discounts,omitempty"`

	// Media for backward compatibility
	Images []string `json:"images,omitempty"`
	Video  *string  `json:"video,omitempty"`

	// Status for backward compatibility
	IsAvailable            bool    `json:"is_available,omitempty"`
	CurrentOdometerReading float64 `json:"current_odometer_reading,omitempty"`
	LastServiceDate        string  `json:"last_service_date,omitempty"`
	NextServiceDue         string  `json:"next_service_due,omitempty"`
	DamagesOrIssues        *string `json:"damages_or_issues,omitempty"`

	CreatedAt string `json:"created_at"`
	UpdatedAt string `json:"updated_at"`
}

// ToCarResponse converts a Car model to CarResponse
func (c *Car) ToCarResponse() CarResponse {
	response := CarResponse{
		ID:                c.ID.String(),
		Make:              c.Make,
		Model:             c.Model,
		Year:              c.Year,
		Variant:           c.Variant,
		FuelType:          c.FuelType,
		Transmission:      c.Transmission,
		BodyType:          c.BodyType,
		Color:             c.Color,
		SeatingCapacity:   c.SeatingCapacity,
		VehicleNumber:     c.VehicleNumber,
		RegistrationState: c.RegistrationState,
		OwnerID:           c.OwnerID.String(),
		CreatedAt:         c.CreatedAt.Format(time.RFC3339),
		UpdatedAt:         c.UpdatedAt.Format(time.RFC3339),
	}

	// Add owner details if available
	if c.Owner.ID != uuid.Nil {
		response.OwnerName = c.Owner.Name
		response.OwnerContact = c.Owner.ContactInfo
	}

	// Add location details if available
	if c.Location != nil {
		response.CurrentLocation = c.Location.CurrentLocation
		response.AvailableBranches = c.Location.AvailableBranches
	}

	// Add rental info if available
	if c.RentalInfo != nil {
		response.RentalPricePerDay = c.RentalInfo.RentalPricePerDay
		response.RentalPricePerHour = c.RentalInfo.RentalPricePerHour
		response.MinimumRentDuration = c.RentalInfo.MinimumRentDuration
		response.MaximumRentDuration = c.RentalInfo.MaximumRentDuration
		response.SecurityDeposit = c.RentalInfo.SecurityDeposit
		response.LateFeePerHour = c.RentalInfo.LateFeePerHour
		response.Discounts = c.RentalInfo.Discounts
	}

	// Add media if available
	if len(c.Media) > 0 {
		var images []string
		for _, media := range c.Media {
			if media.Type == "image" {
				images = append(images, media.URL)
			} else if media.Type == "video" {
				videoURL := media.URL
				response.Video = &videoURL
			}
		}
		response.Images = images
	}

	// Add status if available
	if c.CurrentStatus != nil {
		response.IsAvailable = c.CurrentStatus.IsAvailable
		response.CurrentOdometerReading = c.CurrentStatus.CurrentOdometerReading
		response.LastServiceDate = c.CurrentStatus.LastServiceDate.Format("2006-01-02")
		response.NextServiceDue = c.CurrentStatus.NextServiceDue.Format("2006-01-02")
		response.DamagesOrIssues = c.CurrentStatus.DamagesOrIssues
	}

	return response
}
