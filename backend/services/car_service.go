package services

import (
	"car-rental-backend/database"
	"car-rental-backend/models"
	"errors"
	"time"

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
		Preload("Location").
		Preload("RentalInfo").
		Preload("Media").
		Preload("Documents").
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
		Preload("Location").
		Preload("RentalInfo").
		Preload("Media").
		Preload("Documents").
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
		Preload("Location").
		Preload("RentalInfo").
		Preload("Media").
		Preload("Documents").
		Preload("CurrentStatus").
		Find(&cars).Error

	if err != nil {
		return nil, err
	}

	return cars, nil
}

// CreateCar creates a new car with all its related data
func (s *CarService) CreateCar(car *models.Car, owner *models.Owner, location *models.CarLocation,
	rentalInfo *models.CarRentalInfo, media []models.CarMedia, documents []models.CarDocument,
	status *models.CarStatus) (*models.Car, error) {

	// Begin transaction
	tx := s.db.Begin()

	// Check if owner exists, if not create it
	var existingOwner models.Owner
	if err := tx.Where("id = ?", owner.ID).First(&existingOwner).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			if err := tx.Create(owner).Error; err != nil {
				tx.Rollback()
				return nil, err
			}
		} else {
			tx.Rollback()
			return nil, err
		}
	}

	// Set the owner ID in the car
	car.OwnerID = owner.ID

	// Create the car
	if err := tx.Create(car).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// Set the car ID in related entities
	location.CarID = car.ID
	rentalInfo.CarID = car.ID
	status.CarID = car.ID

	for i := range media {
		media[i].CarID = car.ID
	}

	for i := range documents {
		documents[i].CarID = car.ID
	}

	// Create related entities
	if err := tx.Create(location).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if err := tx.Create(rentalInfo).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if err := tx.Create(status).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if len(media) > 0 {
		if err := tx.Create(&media).Error; err != nil {
			tx.Rollback()
			return nil, err
		}
	}

	if len(documents) > 0 {
		if err := tx.Create(&documents).Error; err != nil {
			tx.Rollback()
			return nil, err
		}
	}

	// Commit transaction
	if err := tx.Commit().Error; err != nil {
		return nil, err
	}

	// Get the complete car with all relations
	return s.GetCarByID(car.ID)
}

// UpdateCar updates a car and its related data
func (s *CarService) UpdateCar(id uuid.UUID, carUpdates map[string]interface{},
	locationUpdates map[string]interface{}, rentalInfoUpdates map[string]interface{},
	statusUpdates map[string]interface{}) (*models.Car, error) {

	// Begin transaction
	tx := s.db.Begin()

	// Update car basic info if provided
	if len(carUpdates) > 0 {
		if err := tx.Model(&models.Car{}).Where("id = ?", id).Updates(carUpdates).Error; err != nil {
			tx.Rollback()
			return nil, err
		}
	}

	// Update location if provided
	if len(locationUpdates) > 0 {
		if err := tx.Model(&models.CarLocation{}).Where("car_id = ?", id).Updates(locationUpdates).Error; err != nil {
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

	if err := tx.Where("car_id = ?", id).Delete(&models.CarDocument{}).Error; err != nil {
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

	if err := tx.Where("car_id = ?", id).Delete(&models.CarLocation{}).Error; err != nil {
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

// AddCarDocument adds a new document to a car
func (s *CarService) AddCarDocument(carID uuid.UUID, documentType string, documentPath string, permitType models.PermitType, expiryDate *time.Time) error {
	document := models.CarDocument{
		CarID:        carID,
		DocumentType: documentType,
		DocumentPath: documentPath,
		PermitType:   permitType,
		ExpiryDate:   expiryDate,
	}

	return s.db.Create(&document).Error
}

// UpdateDocumentExpiry updates the expiry date of a document
func (s *CarService) UpdateDocumentExpiry(documentID uuid.UUID, expiryDate time.Time) error {
	return s.db.Model(&models.CarDocument{}).Where("id = ?", documentID).Update("expiry_date", expiryDate).Error
}

// SearchCars searches for cars based on various criteria
func (s *CarService) SearchCars(make, model, location string, isAvailable *bool, minPrice, maxPrice *float64) ([]models.Car, error) {
	query := s.db.Model(&models.Car{})

	// Join related tables if needed
	if location != "" || isAvailable != nil || minPrice != nil || maxPrice != nil {
		query = query.Joins("LEFT JOIN car_locations ON car_locations.car_id = cars.id")
	}

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

	if location != "" {
		query = query.Where("car_locations.current_location ILIKE ?", "%"+location+"%")
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
		Preload("Location").
		Preload("RentalInfo").
		Preload("Media").
		Preload("Documents").
		Preload("CurrentStatus").
		Find(&cars).Error

	if err != nil {
		return nil, err
	}

	return cars, nil
}
