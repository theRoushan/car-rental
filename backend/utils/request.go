package utils

import (
	"strconv"

	"github.com/gofiber/fiber/v2"
)

// Default pagination values
const (
	DefaultPage     = 1
	DefaultPageSize = 10
	MaxPageSize     = 100
)

// GetPaginationParams extracts pagination parameters from the request query
func GetPaginationParams(c *fiber.Ctx) (page, pageSize int) {
	// Get page parameter with default fallback
	pageQuery := c.Query("page", strconv.Itoa(DefaultPage))
	page, err := strconv.Atoi(pageQuery)
	if err != nil || page < 1 {
		page = DefaultPage
	}

	// Get pageSize parameter with default fallback
	pageSizeQuery := c.Query("limit", strconv.Itoa(DefaultPageSize))
	pageSize, err = strconv.Atoi(pageSizeQuery)
	if err != nil || pageSize < 1 {
		pageSize = DefaultPageSize
	}

	// Limit maximum page size to prevent excessive queries
	if pageSize > MaxPageSize {
		pageSize = MaxPageSize
	}

	return page, pageSize
}

// GetIntParam extracts an integer parameter from the request query
func GetIntParam(c *fiber.Ctx, paramName string, defaultValue int) int {
	paramStr := c.Query(paramName)
	if paramStr == "" {
		return defaultValue
	}

	paramValue, err := strconv.Atoi(paramStr)
	if err != nil {
		return defaultValue
	}

	return paramValue
}

// GetStringParam extracts a string parameter from the request query
func GetStringParam(c *fiber.Ctx, paramName string) string {
	return c.Query(paramName)
}
