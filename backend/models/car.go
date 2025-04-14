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

// CarMedia represents the media assets of a car
type CarMedia struct {
	Images []string `json:"images" gorm:"type:jsonb"`
	Video  *string  `json:"video,omitempty"`
}

// CarLocation represents the location information of a car
type CarLocation struct {
	CurrentLocation   string   `json:"current_location"`
	AvailableBranches []string `json:"available_branches" gorm:"type:jsonb"`
}

// CarRentalInfo represents the rental-related information
type CarRentalInfo struct {
	RentalPricePerDay   float64  `json:"rental_price_per_day"`
	RentalPricePerHour  *float64 `json:"rental_price_per_hour,omitempty"`
	MinimumRentDuration int      `json:"minimum_rent_duration"` // in hours
	MaximumRentDuration int      `json:"maximum_rent_duration"` // in hours
	SecurityDeposit     float64  `json:"security_deposit"`
	LateFeePerHour      float64  `json:"late_fee_per_hour"`
	Discounts           *string  `json:"discounts,omitempty" gorm:"type:jsonb"`
}

// CarDocumentation represents all the documents related to a car
type CarDocumentation struct {
	InsuranceExpiryDate     time.Time  `json:"insurance_expiry_date"`
	PollutionCertValidity   time.Time  `json:"pollution_certificate_validity"`
	RegistrationCertificate string     `json:"registration_certificate"`
	FitnessCertificate      string     `json:"fitness_certificate"`
	PermitType              PermitType `json:"permit_type"`
}

// CarStatus represents the current status and maintenance information
type CarStatus struct {
	IsAvailable            bool      `json:"is_available" gorm:"default:true"`
	CurrentOdometerReading float64   `json:"current_odometer_reading"`
	LastServiceDate        time.Time `json:"last_service_date"`
	NextServiceDue         time.Time `json:"next_service_due"`
	DamagesOrIssues        *string   `json:"damages_or_issues,omitempty"`
}

// OwnerInfo represents the owner's information
type OwnerInfo struct {
	OwnerID     uuid.UUID `json:"owner_id"`
	OwnerName   string    `json:"owner_name"`
	ContactInfo string    `json:"contact_info"`
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

	// Embedded structs for better organization
	Location      CarLocation      `json:"location" gorm:"embedded"`
	RentalInfo    CarRentalInfo    `json:"rental_info" gorm:"embedded"`
	Media         CarMedia         `json:"media" gorm:"embedded"`
	Documentation CarDocumentation `json:"documentation" gorm:"embedded"`
	Status        CarStatus        `json:"status" gorm:"embedded"`
	Owner         OwnerInfo        `json:"owner" gorm:"embedded"`

	// Relationships
	Bookings []Booking `json:"bookings,omitempty"`
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
	Location          CarLocation      `json:"location"`
	RentalInfo        CarRentalInfo    `json:"rental_info"`
	Media             CarMedia         `json:"media"`
	Documentation     CarDocumentation `json:"documentation"`
	Status            CarStatus        `json:"status"`
	Owner             OwnerInfo        `json:"owner"`
	CreatedAt         string           `json:"created_at"`
	UpdatedAt         string           `json:"updated_at"`
}
