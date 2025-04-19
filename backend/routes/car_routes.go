package routes

import (
	"car-rental-backend/controllers"
	"car-rental-backend/middlewares"

	"github.com/gin-gonic/gin"
)

func SetupCarRoutes(router *gin.Engine, carController *controllers.CarController, carCreationController *controllers.CarCreationController) {
	carRoutes := router.Group("/api/v1/cars")
	{
		// Existing routes
		carRoutes.GET("", carController.GetCars)
		carRoutes.GET("/:id", carController.GetCar)
		carRoutes.POST("", middlewares.AdminAuthRequired(), carController.CreateCar)
		carRoutes.PUT("/:id", middlewares.AdminAuthRequired(), carController.UpdateCar)
		carRoutes.DELETE("/:id", middlewares.AdminAuthRequired(), carController.DeleteCar)
		carRoutes.PUT("/:id/toggle-availability", middlewares.AdminAuthRequired(), carController.ToggleCarAvailability)

		// Multi-step car creation routes
		createRoutes := carRoutes.Group("/create", middlewares.AdminAuthRequired())
		{
			createRoutes.POST("/init", carCreationController.InitiateCarCreation)
			createRoutes.POST("/:session_id/basic-details", carCreationController.SaveBasicDetails)
			createRoutes.POST("/:session_id/owner-info", carCreationController.SaveOwnerInfo)
			createRoutes.POST("/:session_id/location-details", carCreationController.SaveLocationDetails)
			createRoutes.POST("/:session_id/rental-info", carCreationController.SaveRentalInfo)
			createRoutes.POST("/:session_id/documents-media", carCreationController.SaveDocumentsMedia)
			createRoutes.POST("/:session_id/status-info", carCreationController.SaveStatusInfo)
			createRoutes.GET("/:session_id/progress", carCreationController.GetCarCreationProgress)
		}
	}
}
