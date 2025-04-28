package models

import (
	"time"

	"golang.org/x/crypto/bcrypt"
)

type UserRole string

const (
	UserRoleUser  UserRole = "user"
	UserRoleAdmin UserRole = "admin"
)

type User struct {
	Base
	Name         string    `json:"name"`
	Email        string    `gorm:"index:idx_users_email,unique,where:deleted_at IS NULL" json:"email"`
	PasswordHash string    `json:"-"`
	Role         UserRole  `json:"role" gorm:"type:varchar(20);default:'user'"`
	Bookings     []Booking `json:"bookings,omitempty"`
}

func (u *User) SetPassword(password string) error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	u.PasswordHash = string(hashedPassword)
	return nil
}

func (u *User) CheckPassword(password string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(u.PasswordHash), []byte(password))
	return err == nil
}

type UserResponse struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Role      UserRole  `json:"role"`
	CreatedAt time.Time `json:"created_at"`
}
