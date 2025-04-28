package controllers

import (
	"car-rental-backend/config"
	"car-rental-backend/database"
	"car-rental-backend/middlewares"
	"car-rental-backend/models"
	"car-rental-backend/utils"

	"github.com/gofiber/fiber/v2"
)

type RegisterRequest struct {
	Name     string `json:"name" validate:"required"`
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required,min=6"`
}

type LoginRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required"`
}

func Register(c *fiber.Ctx) error {
	var req RegisterRequest
	if err := c.BodyParser(&req); err != nil {
		return utils.ValidationErrorResponse(c, "Invalid request body", []string{"Failed to parse request body"})
	}

	// Check if user already exists
	var existingUser models.User
	if result := database.DB.Where("email = ?", req.Email).First(&existingUser); result.Error == nil {
		return utils.ConflictResponse(c, "User with this email already exists", nil)
	}

	user := models.User{
		Name:  req.Name,
		Email: req.Email,
	}

	if err := user.SetPassword(req.Password); err != nil {
		return utils.ServerErrorResponse(c, "Failed to process password")
	}

	if result := database.DB.Create(&user); result.Error != nil {
		return utils.ServerErrorResponse(c, "Failed to create user")
	}

	// Generate JWT token
	cfg := c.Locals("config").(*config.Config)
	token, err := middlewares.GenerateToken(user.ID.String(), user.Role, cfg)
	if err != nil {
		return utils.ServerErrorResponse(c, "Failed to generate token")
	}

	// Create response data
	responseData := fiber.Map{
		"token": token,
		"user": models.UserResponse{
			ID:        user.ID.String(),
			Name:      user.Name,
			Email:     user.Email,
			CreatedAt: user.CreatedAt,
		},
	}

	return utils.SuccessResponse(c, responseData, "User registered successfully")
}

func Login(c *fiber.Ctx) error {
	var req LoginRequest
	if err := c.BodyParser(&req); err != nil {
		return utils.ValidationErrorResponse(c, "Invalid request body", []string{"Failed to parse request body"})
	}

	var user models.User
	if result := database.DB.Where("email = ?", req.Email).First(&user); result.Error != nil {
		return utils.UnauthorizedResponse(c, "Invalid credentials")
	}

	if !user.CheckPassword(req.Password) {
		return utils.UnauthorizedResponse(c, "Invalid credentials")
	}

	// Generate JWT token
	cfg := c.Locals("config").(*config.Config)
	token, err := middlewares.GenerateToken(user.ID.String(), user.Role, cfg)
	if err != nil {
		return utils.ServerErrorResponse(c, "Failed to generate token")
	}

	// Create response data
	responseData := fiber.Map{
		"token": token,
		"user": models.UserResponse{
			ID:        user.ID.String(),
			Name:      user.Name,
			Email:     user.Email,
			CreatedAt: user.CreatedAt,
		},
	}

	return utils.SuccessResponse(c, responseData, "Login successful")
}
