package controllers

import (
	"car-rental-backend/database"
	"car-rental-backend/models"
	"car-rental-backend/utils"

	"github.com/gofiber/fiber/v2"
	"github.com/google/uuid"
)

// OwnerRequest represents the request body for owner operations
type OwnerRequest struct {
	Name        string `json:"name" validate:"required"`
	ContactInfo string `json:"contact_info" validate:"required"`
}

// GetOwners retrieves all owners
func GetOwners(c *fiber.Ctx) error {
	var owners []models.Owner

	if result := database.DB.Find(&owners); result.Error != nil {
		return utils.HandleDatabaseError(c, result.Error)
	}

	return utils.SuccessResponse(c, owners, "Owners fetched successfully")
}

// GetOwner retrieves a specific owner by ID
func GetOwner(c *fiber.Ctx) error {
	id := c.Params("id")
	ownerID, err := uuid.Parse(id)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid owner ID", []string{"Invalid UUID format"})
	}

	var owner models.Owner
	if result := database.DB.Preload("Cars").First(&owner, "id = ?", ownerID); result.Error != nil {
		return utils.HandleDatabaseError(c, result.Error)
	}

	return utils.SuccessResponse(c, owner, "Owner fetched successfully")
}

// CreateOwner creates a new owner
func CreateOwner(c *fiber.Ctx) error {
	var req OwnerRequest
	if err := c.BodyParser(&req); err != nil {
		return utils.ValidationErrorResponse(c, "Invalid request body", []string{
			"Failed to parse request body: " + err.Error(),
		})
	}

	// Validate request
	if validationErrors := utils.ValidateStruct(req); len(validationErrors) > 0 {
		return utils.ValidationErrorResponse(c, "Validation failed", validationErrors)
	}

	// Create owner
	owner := models.Owner{
		Name:        req.Name,
		ContactInfo: req.ContactInfo,
	}

	if result := database.DB.Create(&owner); result.Error != nil {
		return utils.HandleDatabaseError(c, result.Error)
	}

	return utils.SuccessResponse(c, owner, "Owner created successfully")
}

// UpdateOwner updates an existing owner
func UpdateOwner(c *fiber.Ctx) error {
	id := c.Params("id")
	ownerID, err := uuid.Parse(id)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid owner ID", []string{"Invalid UUID format"})
	}

	var req OwnerRequest
	if err := c.BodyParser(&req); err != nil {
		return utils.ValidationErrorResponse(c, "Invalid request body", []string{
			"Failed to parse request body: " + err.Error(),
		})
	}

	// Validate request
	if validationErrors := utils.ValidateStruct(req); len(validationErrors) > 0 {
		return utils.ValidationErrorResponse(c, "Validation failed", validationErrors)
	}

	// Check if owner exists
	var owner models.Owner
	if result := database.DB.First(&owner, "id = ?", ownerID); result.Error != nil {
		return utils.HandleDatabaseError(c, result.Error)
	}

	// Update owner
	owner.Name = req.Name
	owner.ContactInfo = req.ContactInfo

	if result := database.DB.Save(&owner); result.Error != nil {
		return utils.HandleDatabaseError(c, result.Error)
	}

	return utils.SuccessResponse(c, owner, "Owner updated successfully")
}

// DeleteOwner deletes an owner
func DeleteOwner(c *fiber.Ctx) error {
	id := c.Params("id")
	ownerID, err := uuid.Parse(id)
	if err != nil {
		return utils.ValidationErrorResponse(c, "Invalid owner ID", []string{"Invalid UUID format"})
	}

	// Check if owner exists
	var owner models.Owner
	if result := database.DB.First(&owner, "id = ?", ownerID); result.Error != nil {
		return utils.HandleDatabaseError(c, result.Error)
	}

	// Check if owner has associated cars
	var carsCount int64
	if result := database.DB.Model(&models.Car{}).Where("owner_id = ?", ownerID).Count(&carsCount); result.Error != nil {
		return utils.HandleDatabaseError(c, result.Error)
	}

	if carsCount > 0 {
		return utils.ConflictResponse(c, "Cannot delete owner with associated cars", []string{
			"Owner has associated cars. Please delete or reassign cars before deleting the owner.",
		})
	}

	// Delete owner
	if result := database.DB.Delete(&owner); result.Error != nil {
		return utils.HandleDatabaseError(c, result.Error)
	}

	return utils.SuccessResponse(c, nil, "Owner deleted successfully")
}
