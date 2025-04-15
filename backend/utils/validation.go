package utils

import (
	"fmt"
	"net/url"
	"reflect"
	"regexp"
	"strings"
	"time"

	"github.com/go-playground/validator/v10"
	"github.com/google/uuid"
)

var validate *validator.Validate

func init() {
	validate = validator.New()

	// Register custom validation
	validate.RegisterValidation("validVehicleNumber", ValidVehicleNumber)
	validate.RegisterValidation("validUUID", ValidUUID)
	validate.RegisterValidation("validDate", ValidDate)
	validate.RegisterValidation("futureDate", ValidFutureDate)
}

// ValidateStruct validates a struct using the validator package and returns a list of validation errors
func ValidateStruct(s interface{}) []string {
	var errors []string
	err := validate.Struct(s)
	if err != nil {
		for _, err := range err.(validator.ValidationErrors) {
			field := toSnakeCase(err.Field())
			errors = append(errors, fmt.Sprintf(
				"Field validation for '%s' failed on the '%s' tag",
				field,
				err.Tag(),
			))
		}
	}
	return errors
}

// ValidVehicleNumber validates a vehicle number format (e.g., "KA01AB1234")
func ValidVehicleNumber(fl validator.FieldLevel) bool {
	// Check format like "KA01AB1234" or "MH02CD5678"
	vehicleNumberPattern := regexp.MustCompile(`^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$`)
	return vehicleNumberPattern.MatchString(fl.Field().String())
}

// ValidUUID validates a UUID string
func ValidUUID(fl validator.FieldLevel) bool {
	_, err := uuid.Parse(fl.Field().String())
	return err == nil
}

// ValidDate validates a date string in format YYYY-MM-DD
func ValidDate(fl validator.FieldLevel) bool {
	_, err := time.Parse("2006-01-02", fl.Field().String())
	return err == nil
}

// ValidFutureDate validates that a date is in the future
func ValidFutureDate(fl validator.FieldLevel) bool {
	date, err := time.Parse("2006-01-02", fl.Field().String())
	if err != nil {
		return false
	}
	return date.After(time.Now())
}

// IsValidEmail checks if a string is a valid email address
func IsValidEmail(email string) bool {
	emailPattern := regexp.MustCompile(`^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`)
	return emailPattern.MatchString(email)
}

// IsValidURL checks if a string is a valid URL
func IsValidURL(str string) bool {
	u, err := url.Parse(str)
	return err == nil && u.Scheme != "" && u.Host != ""
}

// IsValidPhoneNumber checks if a string is a valid phone number
func IsValidPhoneNumber(phone string) bool {
	// Simple pattern for demonstration, can be made more sophisticated
	phonePattern := regexp.MustCompile(`^\+?[0-9]{10,15}$`)
	return phonePattern.MatchString(phone)
}

// IsStrongPassword checks if a password meets strength requirements
func IsStrongPassword(password string) bool {
	// At least 8 characters with a mix of upper, lower, number, and special
	if len(password) < 8 {
		return false
	}

	hasUpper := regexp.MustCompile(`[A-Z]`).MatchString(password)
	hasLower := regexp.MustCompile(`[a-z]`).MatchString(password)
	hasDigit := regexp.MustCompile(`[0-9]`).MatchString(password)
	hasSpecial := regexp.MustCompile(`[^a-zA-Z0-9]`).MatchString(password)

	return hasUpper && hasLower && hasDigit && hasSpecial
}

// toSnakeCase converts a camelCase string to snake_case
func toSnakeCase(s string) string {
	var result string
	for i, r := range s {
		if i > 0 && r >= 'A' && r <= 'Z' {
			result += "_"
		}
		result += strings.ToLower(string(r))
	}
	return result
}

// getFieldName extracts the struct field name
func getFieldName(s interface{}, field string) (string, bool) {
	t := reflect.TypeOf(s)
	if t.Kind() == reflect.Ptr {
		t = t.Elem()
	}
	if t.Kind() != reflect.Struct {
		return "", false
	}

	for i := 0; i < t.NumField(); i++ {
		f := t.Field(i)
		if f.Name == field {
			return f.Tag.Get("json"), true
		}
	}
	return "", false
}
