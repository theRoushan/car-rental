package utils

import (
	"reflect"
	"strings"

	"github.com/go-playground/validator/v10"
)

var validate = validator.New()

func init() {
	// Register custom validation tags
	validate.RegisterValidation("oneof", validateOneOf)
}

// ValidateStruct validates a struct using the validator package
func ValidateStruct(s interface{}) []string {
	var errors []string
	err := validate.Struct(s)
	if err != nil {
		for _, err := range err.(validator.ValidationErrors) {
			errors = append(errors, formatError(err))
		}
	}
	return errors
}

// formatError formats a validation error into a readable string
func formatError(err validator.FieldError) string {
	field := err.Field()
	value := err.Value()
	tag := err.Tag()
	param := err.Param()

	switch tag {
	case "required":
		return field + " is required"
	case "min":
		if strings.Contains(field, "Duration") || strings.Contains(field, "Capacity") {
			return field + " must be at least " + param + " hours"
		} else if strings.Contains(field, "Price") || strings.Contains(field, "Deposit") || strings.Contains(field, "Fee") {
			return field + " must be at least " + param + " dollars"
		} else if strings.Contains(field, "Year") {
			return field + " must be at least " + param
		} else if strings.Contains(field, "Reading") {
			return field + " must be at least " + param + " km"
		} else {
			return field + " must be at least " + param
		}
	case "max":
		if strings.Contains(field, "Capacity") {
			return field + " must be at most " + param + " seats"
		} else if strings.Contains(field, "Year") {
			return field + " must be at most " + param
		} else {
			return field + " must be at most " + param
		}
	case "oneof":
		options := strings.Split(param, " ")
		return field + " must be one of: " + strings.Join(options, ", ")
	default:
		return field + " failed validation: " + tag + " with value " + toString(value)
	}
}

// validateOneOf is a custom validation function for the "oneof" tag
func validateOneOf(fl validator.FieldLevel) bool {
	value := fl.Field().String()
	params := strings.Split(fl.Param(), " ")
	for _, param := range params {
		if value == param {
			return true
		}
	}
	return false
}

// toString converts a value to a string
func toString(v interface{}) string {
	return reflect.ValueOf(v).String()
}
