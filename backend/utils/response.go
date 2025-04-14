package utils

import (
	"github.com/gofiber/fiber/v2"
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
func ConflictResponse(c *fiber.Ctx, message string) error {
	return ErrorResponse(c, message, nil, fiber.StatusConflict)
}

// ServerErrorResponse creates a server error response
func ServerErrorResponse(c *fiber.Ctx, message string) error {
	return ErrorResponse(c, message, nil, fiber.StatusInternalServerError)
}
