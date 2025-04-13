package models

type Car struct {
	Base
	Name         string    `json:"name"`
	Model        string    `json:"model"`
	LicensePlate string    `gorm:"uniqueIndex" json:"license_plate"`
	Location     string    `json:"location"`
	HourlyRate   float64   `json:"hourly_rate"`
	IsAvailable  bool      `json:"is_available" gorm:"default:true"`
	Bookings     []Booking `json:"bookings,omitempty"`
}

type CarResponse struct {
	ID           string  `json:"id"`
	Name         string  `json:"name"`
	Model        string  `json:"model"`
	LicensePlate string  `json:"license_plate"`
	Location     string  `json:"location"`
	HourlyRate   float64 `json:"hourly_rate"`
	IsAvailable  bool    `json:"is_available"`
	CreatedAt    string  `json:"created_at"`
	UpdatedAt    string  `json:"updated_at"`
}
