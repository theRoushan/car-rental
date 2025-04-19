package models

import (
	"time"

	"github.com/google/uuid"
)

// CarCreationState represents the current state of car creation
type CarCreationState string

const (
	BasicDetails    CarCreationState = "basic_details"
	OwnerInfo       CarCreationState = "owner_info"
	LocationDetails CarCreationState = "location_details"
	RentalInfo      CarCreationState = "rental_info"
	DocumentsMedia  CarCreationState = "documents_media"
	StatusInfo      CarCreationState = "status_info"
	Completed       CarCreationState = "completed"
)

// CarCreationSession represents a car creation session
type CarCreationSession struct {
	Base
	CarID     uuid.UUID        `json:"car_id" gorm:"uniqueIndex"`
	State     CarCreationState `json:"state"`
	ExpiresAt time.Time        `json:"expires_at"`
}

// BasicDetailsStep represents the first step of car creation
type BasicDetailsStep struct {
	Make              string           `json:"make" binding:"required"`
	Model             string           `json:"model" binding:"required"`
	Year              int              `json:"year" binding:"required"`
	Variant           string           `json:"variant" binding:"required"`
	FuelType          FuelType         `json:"fuel_type" binding:"required"`
	Transmission      TransmissionType `json:"transmission" binding:"required"`
	BodyType          BodyType         `json:"body_type" binding:"required"`
	Color             string           `json:"color" binding:"required"`
	SeatingCapacity   int              `json:"seating_capacity" binding:"required"`
	VehicleNumber     string           `json:"vehicle_number" binding:"required"`
	RegistrationState string           `json:"registration_state" binding:"required"`
}

// OwnerInfoStep represents the owner information step
type OwnerInfoStep struct {
	Name        string `json:"name" binding:"required"`
	ContactInfo string `json:"contact_info" binding:"required"`
}

// LocationDetailsStep represents the location information step
type LocationDetailsStep struct {
	CurrentLocation   string   `json:"current_location" binding:"required"`
	AvailableBranches []string `json:"available_branches" binding:"required"`
}

// RentalInfoStep represents the rental information step
type RentalInfoStep struct {
	RentalPricePerDay   float64  `json:"rental_price_per_day" binding:"required"`
	RentalPricePerHour  *float64 `json:"rental_price_per_hour"`
	MinimumRentDuration int      `json:"minimum_rent_duration" binding:"required"`
	MaximumRentDuration int      `json:"maximum_rent_duration" binding:"required"`
	SecurityDeposit     float64  `json:"security_deposit" binding:"required"`
	LateFeePerHour      float64  `json:"late_fee_per_hour" binding:"required"`
	Discounts           *string  `json:"discounts"`
}

// DocumentsMediaStep represents the documents and media step
type DocumentsMediaStep struct {
	Documents []CarDocument `json:"documents" binding:"required"`
	Media     []CarMedia    `json:"media" binding:"required"`
}

// StatusInfoStep represents the status and maintenance step
type StatusInfoStep struct {
	IsAvailable            bool      `json:"is_available"`
	CurrentOdometerReading float64   `json:"current_odometer_reading" binding:"required"`
	LastServiceDate        time.Time `json:"last_service_date" binding:"required"`
	NextServiceDue         time.Time `json:"next_service_due" binding:"required"`
	DamagesOrIssues        *string   `json:"damages_or_issues"`
}

// StepResponse represents the response for each step
type StepResponse struct {
	SessionID   string           `json:"session_id"`
	CarID       string           `json:"car_id"`
	CurrentStep CarCreationState `json:"current_step"`
	NextStep    CarCreationState `json:"next_step"`
	Message     string           `json:"message"`
}
