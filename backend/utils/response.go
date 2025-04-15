package utils

import (
	"errors"
	"fmt"
	"strings"

	"github.com/gofiber/fiber/v2"
	"github.com/lib/pq"
	"gorm.io/gorm"
)

// ApiResponse represents a standardized API response
type ApiResponse struct {
	Success    bool        `json:"success"`
	Message    string      `json:"message,omitempty"`
	Data       interface{} `json:"data,omitempty"`
	Errors     []string    `json:"errors,omitempty"`
	StatusCode int         `json:"statusCode,omitempty"`
}

// SuccessResponse creates a successful API response
func SuccessResponse(c *fiber.Ctx, data interface{}, message string) error {
	statusCode := fiber.StatusOK
	if c.Method() == "POST" {
		statusCode = fiber.StatusCreated
	}

	response := ApiResponse{
		Success:    true,
		Message:    message,
		Data:       data,
		StatusCode: statusCode,
	}

	return c.Status(statusCode).JSON(response)
}

// ErrorResponse creates an error API response
func ErrorResponse(c *fiber.Ctx, message string, errors []string, statusCode int) error {
	if statusCode == 0 {
		statusCode = fiber.StatusBadRequest
	}

	// Format error messages
	formattedErrors := make([]string, len(errors))
	for i, err := range errors {
		formattedErrors[i] = err
	}

	response := ApiResponse{
		Success:    false,
		Message:    message,
		Errors:     formattedErrors,
		StatusCode: statusCode,
	}

	return c.Status(statusCode).JSON(response)
}

// ValidationErrorResponse creates a validation error response
func ValidationErrorResponse(c *fiber.Ctx, message string, errors []string) error {
	return ErrorResponse(c, message, errors, fiber.StatusBadRequest)
}

// NotFoundResponse creates a not found error response
func NotFoundResponse(c *fiber.Ctx, message string) error {
	return ErrorResponse(c, message, nil, fiber.StatusNotFound)
}

// UnauthorizedResponse creates an unauthorized error response
func UnauthorizedResponse(c *fiber.Ctx, message string) error {
	return ErrorResponse(c, message, nil, fiber.StatusUnauthorized)
}

// ForbiddenResponse creates a forbidden error response
func ForbiddenResponse(c *fiber.Ctx, message string) error {
	return ErrorResponse(c, message, nil, fiber.StatusForbidden)
}

// ConflictResponse creates a conflict error response
func ConflictResponse(c *fiber.Ctx, message string, errors []string) error {
	return ErrorResponse(c, message, errors, fiber.StatusConflict)
}

// ServerErrorResponse creates a server error response
func ServerErrorResponse(c *fiber.Ctx, message string) error {
	return ErrorResponse(c, message, nil, fiber.StatusInternalServerError)
}

// HandleDatabaseError converts a database error to an appropriate API response
func HandleDatabaseError(c *fiber.Ctx, err error) error {
	// Check for common database errors
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return NotFoundResponse(c, "Resource not found")
	}

	// Check for duplicate key errors
	var pqErr *pq.Error
	if errors.As(err, &pqErr) {
		if pqErr.Code == "23505" { // Unique violation
			constraint := pqErr.Constraint
			field := extractFieldFromConstraint(constraint)
			return ConflictResponse(c, "Duplicate entry", []string{
				fmt.Sprintf("The %s already exists in the system", field),
			})
		}
	}

	// Check for foreign key violations
	if err != nil && strings.Contains(err.Error(), "violates foreign key constraint") {
		return ValidationErrorResponse(c, "Invalid reference", []string{
			"Referenced resource does not exist",
		})
	}

	// Default to internal server error
	return ServerErrorResponse(c, "Database operation failed: "+err.Error())
}

// IsDuplicateKeyError checks if an error is a duplicate key error for a specific constraint
func IsDuplicateKeyError(err error, constraintKey string) bool {
	if pqErr, ok := err.(*pq.Error); ok {
		return pqErr.Code == "23505" && strings.Contains(pqErr.Constraint, constraintKey)
	}
	return false
}

// extractFieldFromConstraint extracts the field name from a constraint name
func extractFieldFromConstraint(constraint string) string {
	// Common constraint naming patterns:
	// - table_name_field_name_key
	// - table_name_field_name_unique
	// - idx_table_name_field_name
	parts := strings.Split(constraint, "_")
	if len(parts) > 2 {
		// Try to extract a meaningful field name
		for i, part := range parts {
			if part == "key" || part == "unique" || part == "idx" {
				if i > 0 {
					return strings.Join(parts[i-1:i], "_")
				}
			}
		}
		// Fallback to the second-to-last part if we can't find a pattern
		if len(parts) >= 2 {
			return parts[len(parts)-2]
		}
	}
	return "value" // Default fallback
}
