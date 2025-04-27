package models

import "math"

// Pagination represents metadata for paginated responses
type Pagination struct {
	CurrentPage int   `json:"current_page"`
	PageSize    int   `json:"page_size"`
	TotalItems  int64 `json:"total_items"`
	TotalPages  int   `json:"total_pages"`
	HasNext     bool  `json:"has_next"`
	HasPrev     bool  `json:"has_prev"`
}

// PaginatedResponse is a wrapper for paginated data
type PaginatedResponse struct {
	Items      interface{} `json:"items"`
	Pagination Pagination  `json:"pagination"`
}

// NewPagination creates a new pagination object
func NewPagination(totalItems int64, currentPage, pageSize int) Pagination {
	// Ensure minimum values for page and size
	if currentPage < 1 {
		currentPage = 1
	}
	if pageSize < 1 {
		pageSize = 10
	}

	// Calculate total pages
	totalPages := int(math.Ceil(float64(totalItems) / float64(pageSize)))

	return Pagination{
		CurrentPage: currentPage,
		PageSize:    pageSize,
		TotalItems:  totalItems,
		TotalPages:  totalPages,
		HasNext:     currentPage < totalPages,
		HasPrev:     currentPage > 1,
	}
}
