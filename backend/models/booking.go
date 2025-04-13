package models

import (
	"time"

	"github.com/google/uuid"
)

type BookingStatus string

const (
	BookingStatusBooked    BookingStatus = "BOOKED"
	BookingStatusCancelled BookingStatus = "CANCELLED"
	BookingStatusCompleted BookingStatus = "COMPLETED"
)

type Booking struct {
	Base
	UserID     uuid.UUID     `json:"user_id"`
	User       User          `json:"user"`
	CarID      uuid.UUID     `json:"car_id"`
	Car        Car           `json:"car"`
	StartTime  time.Time     `json:"start_time"`
	EndTime    time.Time     `json:"end_time"`
	Status     BookingStatus `json:"status" gorm:"type:varchar(20)"`
	TotalPrice float64       `json:"total_price"`
}

type BookingResponse struct {
	ID         string        `json:"id"`
	UserID     string        `json:"user_id"`
	CarID      string        `json:"car_id"`
	StartTime  string        `json:"start_time"`
	EndTime    string        `json:"end_time"`
	Status     BookingStatus `json:"status"`
	TotalPrice float64       `json:"total_price"`
	CreatedAt  string        `json:"created_at"`
	UpdatedAt  string        `json:"updated_at"`
}
