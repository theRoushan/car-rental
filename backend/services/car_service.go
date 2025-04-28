package services

import (
	"car-rental-backend/database"
	"car-rental-backend/models"
	"errors"
	"fmt"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// CarService handles all car-related database operations
type CarService struct {
	db *gorm.DB
}

// NewCarService creates a new car service
func NewCarService() *CarService {
	return &CarService{
		db: database.GetDB(),
	}
}

// GetCarByID retrieves a car and its related data by ID
func (s *CarService) GetCarByID(id uuid.UUID) (*models.Car, error) {
	var car models.Car

	err := s.db.Preload("Owner").
		Preload("RentalInfo").
		Preload("Media").
		Preload("CurrentStatus").
		First(&car, "id = ?", id).Error

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("car not found")
		}
		return nil, err
	}

	return &car, nil
}

// GetAllCars retrieves all cars with their related data
func (s *CarService) GetAllCars() ([]models.Car, error) {
	var cars []models.Car

	err := s.db.Preload("Owner").
		Preload("RentalInfo").
		Preload("Media").
		Preload("CurrentStatus").
		Find(&cars).Error

	if err != nil {
		return nil, err
	}

	return cars, nil
}

// GetAvailableCars retrieves all available cars
func (s *CarService) GetAvailableCars() ([]models.Car, error) {
	var cars []models.Car

	err := s.db.Joins("JOIN car_statuses ON car_statuses.car_id = cars.id").
		Where("car_statuses.is_available = ?", true).
		Preload("Owner").
		Preload("RentalInfo").
		Preload("Media").
		Preload("CurrentStatus").
		Find(&cars).Error

	if err != nil {
		return nil, err
	}

	return cars, nil
}

// CreateCarWithoutDocAndLoc creates a new car without documents and location
func (s *CarService) CreateCarWithoutDocAndLoc(car *models.Car, ownerID uuid.UUID,
	rentalInfo *models.CarRentalInfo, media []models.CarMedia,
	status *models.CarStatus) (*models.Car, error) {

	// Input validation
	if car == nil || rentalInfo == nil || status == nil {
		return nil, errors.New("all required entities must be provided")
	}

	// Begin transaction
	tx := s.db.Begin()
	if tx.Error != nil {
		return nil, fmt.Errorf("failed to begin transaction: %w", tx.Error)
	}

	// Ensure we rollback on panics
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	// Check if car with this vehicle number already exists
	var count int64
	if err := tx.Model(&models.Car{}).Where("vehicle_number = ?", car.VehicleNumber).Count(&count).Error; err != nil {
		tx.Rollback()
		return nil, fmt.Errorf("failed to check for duplicate vehicle number: %w", err)
	}
	if count > 0 {
		tx.Rollback()
		return nil, fmt.Errorf("vehicle number %s already exists", car.VehicleNumber)
	}

	// Check if owner exists
	var existingOwner models.Owner
	if err := tx.Where("id = ?", ownerID).First(&existingOwner).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			tx.Rollback()
			return nil, fmt.Errorf("owner with ID %s does not exist", ownerID)
		} else {
			tx.Rollback()
			return nil, fmt.Errorf("failed to check owner existence: %w", err)
		}
	}

	// Set the owner ID in the car
	car.OwnerID = ownerID

	// Create the car
	if err := tx.Create(car).Error; err != nil {
		tx.Rollback()
		return nil, fmt.Errorf("failed to create car: %w", err)
	}

	// Set the car ID in related entities
	rentalInfo.CarID = car.ID
	status.CarID = car.ID

	for i := range media {
		media[i].CarID = car.ID
	}

	// Create related entities
	if err := tx.Create(rentalInfo).Error; err != nil {
		tx.Rollback()
		return nil, fmt.Errorf("failed to create rental info: %w", err)
	}

	for _, m := range media {
		if err := tx.Create(&m).Error; err != nil {
			tx.Rollback()
			return nil, fmt.Errorf("failed to create media: %w", err)
		}
	}

	if err := tx.Create(status).Error; err != nil {
		tx.Rollback()
		return nil, fmt.Errorf("failed to create status: %w", err)
	}

	// Commit transaction
	if err := tx.Commit().Error; err != nil {
		return nil, fmt.Errorf("failed to commit transaction: %w", err)
	}

	// Return the car with all relationships loaded
	return s.GetCarByID(car.ID)
}

// UpdateCar updates a car and its related entities
func (s *CarService) UpdateCar(id uuid.UUID, carUpdates map[string]interface{},
	rentalInfoUpdates map[string]interface{}, statusUpdates map[string]interface{}) (*models.Car, error) {

	// Begin transaction
	tx := s.db.Begin()

	// Update car basic info if provided
	if len(carUpdates) > 0 {
		if err := tx.Model(&models.Car{}).Where("id = ?", id).Updates(carUpdates).Error; err != nil {
			tx.Rollback()
			return nil, err
		}
	}

	// Update rental info if provided
	if len(rentalInfoUpdates) > 0 {
		if err := tx.Model(&models.CarRentalInfo{}).Where("car_id = ?", id).Updates(rentalInfoUpdates).Error; err != nil {
			tx.Rollback()
			return nil, err
		}
	}

	// Update status if provided
	if len(statusUpdates) > 0 {
		if err := tx.Model(&models.CarStatus{}).Where("car_id = ?", id).Updates(statusUpdates).Error; err != nil {
			tx.Rollback()
			return nil, err
		}
	}

	// Commit transaction
	if err := tx.Commit().Error; err != nil {
		return nil, err
	}

	// Get the updated car with all relations
	return s.GetCarByID(id)
}

// UpdateCarAvailability updates a car's availability status
func (s *CarService) UpdateCarAvailability(id uuid.UUID, isAvailable bool) error {
	return s.db.Model(&models.CarStatus{}).Where("car_id = ?", id).Update("is_available", isAvailable).Error
}

// DeleteCar deletes a car and all its related data
func (s *CarService) DeleteCar(id uuid.UUID) error {
	// Begin transaction
	tx := s.db.Begin()

	// Delete related entities first
	if err := tx.Where("car_id = ?", id).Delete(&models.CarStatus{}).Error; err != nil {
		tx.Rollback()
		return err
	}

	if err := tx.Where("car_id = ?", id).Delete(&models.CarMedia{}).Error; err != nil {
		tx.Rollback()
		return err
	}

	if err := tx.Where("car_id = ?", id).Delete(&models.CarRentalInfo{}).Error; err != nil {
		tx.Rollback()
		return err
	}

	// Finally delete the car
	if err := tx.Delete(&models.Car{}, id).Error; err != nil {
		tx.Rollback()
		return err
	}

	// Commit transaction
	return tx.Commit().Error
}

// GetCarImages retrieves all images for a car
func (s *CarService) GetCarImages(carID uuid.UUID) ([]string, error) {
	var media []models.CarMedia
	var images []string

	err := s.db.Where("car_id = ? AND type = 'image'", carID).Find(&media).Error
	if err != nil {
		return nil, err
	}

	for _, m := range media {
		images = append(images, m.URL)
	}

	return images, nil
}

// GetCarVideo retrieves the video URL for a car if it exists
func (s *CarService) GetCarVideo(carID uuid.UUID) (*string, error) {
	var media models.CarMedia

	result := s.db.Where("car_id = ? AND type = 'video'", carID).First(&media)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, result.Error
	}

	return &media.URL, nil
}

// AddCarMedia adds new media to a car
func (s *CarService) AddCarMedia(carID uuid.UUID, mediaType string, url string, isPrimary bool) error {
	media := models.CarMedia{
		CarID:     carID,
		Type:      mediaType,
		URL:       url,
		IsPrimary: isPrimary,
	}

	// If setting as primary, unset any existing primary images
	if isPrimary && mediaType == "image" {
		// Begin transaction
		tx := s.db.Begin()

		if err := tx.Model(&models.CarMedia{}).
			Where("car_id = ? AND type = 'image' AND is_primary = ?", carID, true).
			Update("is_primary", false).Error; err != nil {
			tx.Rollback()
			return err
		}

		if err := tx.Create(&media).Error; err != nil {
			tx.Rollback()
			return err
		}

		return tx.Commit().Error
	}

	return s.db.Create(&media).Error
}

// RemoveCarMedia removes media from a car
func (s *CarService) RemoveCarMedia(mediaID uuid.UUID) error {
	return s.db.Delete(&models.CarMedia{}, mediaID).Error
}

// SearchCars searches for cars based on various criteria
func (s *CarService) SearchCars(make, model string, isAvailable *bool, minPrice, maxPrice *float64) ([]models.Car, error) {
	query := s.db.Model(&models.Car{})

	// Join related tables if needed
	if isAvailable != nil || minPrice != nil || maxPrice != nil {
		query = query.Joins("LEFT JOIN car_statuses ON car_statuses.car_id = cars.id")
	}

	if minPrice != nil || maxPrice != nil {
		query = query.Joins("LEFT JOIN car_rental_infos ON car_rental_infos.car_id = cars.id")
	}

	// Apply filters
	if make != "" {
		query = query.Where("cars.make ILIKE ?", "%"+make+"%")
	}

	if model != "" {
		query = query.Where("cars.model ILIKE ?", "%"+model+"%")
	}

	if isAvailable != nil {
		query = query.Where("car_statuses.is_available = ?", *isAvailable)
	}

	if minPrice != nil {
		query = query.Where("car_rental_infos.rental_price_per_day >= ?", *minPrice)
	}

	if maxPrice != nil {
		query = query.Where("car_rental_infos.rental_price_per_day <= ?", *maxPrice)
	}

	// Execute the query
	var cars []models.Car
	err := query.
		Preload("Owner").
		Preload("RentalInfo").
		Preload("Media").
		Preload("CurrentStatus").
		Find(&cars).Error

	if err != nil {
		return nil, err
	}

	return cars, nil
}

// VehicleNumberExists checks if a vehicle number already exists in the database
func (s *CarService) VehicleNumberExists(vehicleNumber string) (bool, error) {
	var count int64
	err := s.db.Model(&models.Car{}).Where("vehicle_number = ?", vehicleNumber).Count(&count).Error
	if err != nil {
		return false, err
	}
	return count > 0, nil
}

// OwnerExists checks if an owner with the given ID exists in the database
func (s *CarService) OwnerExists(ownerID uuid.UUID) (bool, error) {
	var owner models.Owner
	err := s.db.Where("id = ?", ownerID).First(&owner).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return false, nil
		}
		return false, err
	}
	return true, nil
}

// GetAllCarsPaginated retrieves cars with pagination and optional filters
func (s *CarService) GetAllCarsPaginated(page, pageSize int, filters map[string]interface{}) ([]models.Car, int64, error) {
	var cars []models.Car
	var totalItems int64
	var loadBookings bool

	// Start building the query
	query := s.db.Model(&models.Car{})
	countQuery := s.db.Model(&models.Car{})

	// Apply filters if they exist
	if filters != nil {
		// Make - case insensitive partial match
		if make, ok := filters["make"].(string); ok && make != "" {
			query = query.Where("make ILIKE ?", "%"+make+"%")
			countQuery = countQuery.Where("make ILIKE ?", "%"+make+"%")
		}

		// Model - case insensitive partial match
		if model, ok := filters["model"].(string); ok && model != "" {
			query = query.Where("model ILIKE ?", "%"+model+"%")
			countQuery = countQuery.Where("model ILIKE ?", "%"+model+"%")
		}

		// Vehicle Number - case insensitive partial match
		if vehicleNumber, ok := filters["vehicle_number"].(string); ok && vehicleNumber != "" {
			query = query.Where("vehicle_number ILIKE ?", "%"+vehicleNumber+"%")
			countQuery = countQuery.Where("vehicle_number ILIKE ?", "%"+vehicleNumber+"%")
		}

		// Year - exact match
		if year, ok := filters["year"].(int); ok && year > 0 {
			query = query.Where("year = ?", year)
			countQuery = countQuery.Where("year = ?", year)
		}

		// Min Year - range
		if minYear, ok := filters["min_year"].(int); ok && minYear > 0 {
			query = query.Where("year >= ?", minYear)
			countQuery = countQuery.Where("year >= ?", minYear)
		}

		// Max Year - range
		if maxYear, ok := filters["max_year"].(int); ok && maxYear > 0 {
			query = query.Where("year <= ?", maxYear)
			countQuery = countQuery.Where("year <= ?", maxYear)
		}

		// Fuel Type - exact match
		if fuelType, ok := filters["fuel_type"].(string); ok && fuelType != "" {
			query = query.Where("fuel_type = ?", fuelType)
			countQuery = countQuery.Where("fuel_type = ?", fuelType)
		}

		// Transmission - exact match
		if transmission, ok := filters["transmission"].(string); ok && transmission != "" {
			query = query.Where("transmission = ?", transmission)
			countQuery = countQuery.Where("transmission = ?", transmission)
		}

		// Body Type - exact match
		if bodyType, ok := filters["body_type"].(string); ok && bodyType != "" {
			query = query.Where("body_type = ?", bodyType)
			countQuery = countQuery.Where("body_type = ?", bodyType)
		}

		// Is Available - for filtering available cars
		if isAvailable, ok := filters["is_available"].(bool); ok && isAvailable {
			query = query.Joins("JOIN car_statuses ON car_statuses.car_id = cars.id").
				Where("car_statuses.is_available = ?", true)
			countQuery = countQuery.Joins("JOIN car_statuses ON car_statuses.car_id = cars.id").
				Where("car_statuses.is_available = ?", true)
		}

		// Check if we need to load bookings
		if _, ok := filters["load_bookings"]; ok {
			loadBookings = true
		}
	}

	// Count total items for pagination - use a simpler count query
	// This avoids the slow query by using a more optimized count approach
	if err := countQuery.Count(&totalItems).Error; err != nil {
		return nil, 0, err
	}

	// Apply pagination
	offset := (page - 1) * pageSize
	query = query.Offset(offset).Limit(pageSize)

	// Apply ordering
	query = query.Order("created_at DESC")

	// Build the preload query based on needs
	preloadQuery := query.Preload("Owner").
		Preload("RentalInfo").
		Preload("Media").
		Preload("CurrentStatus")

	// Conditionally preload bookings
	if loadBookings {
		preloadQuery = preloadQuery.Preload("Bookings")
	}

	// Execute the query with preloaded relationships
	err := preloadQuery.Find(&cars).Error

	if err != nil {
		return nil, 0, err
	}

	// Safety check for empty results
	if cars == nil {
		cars = []models.Car{} // Return empty slice instead of nil to avoid nil pointer dereference
	}

	return cars, totalItems, nil
}
