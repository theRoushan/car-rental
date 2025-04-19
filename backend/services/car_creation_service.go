package services

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"car-rental-backend/models"
)

type CarCreationService struct {
	db *gorm.DB
}

func NewCarCreationService(db *gorm.DB) *CarCreationService {
	return &CarCreationService{db: db}
}

// InitiateCarCreation starts a new car creation session
func (s *CarCreationService) InitiateCarCreation() (*models.CarCreationSession, error) {
	carID := uuid.New()
	session := &models.CarCreationSession{
		CarID:     carID,
		State:     models.BasicDetails,
		ExpiresAt: time.Now().Add(24 * time.Hour), // Session expires in 24 hours
	}

	if err := s.db.Create(session).Error; err != nil {
		return nil, err
	}

	return session, nil
}

// ValidateSession checks if the session is valid and not expired
func (s *CarCreationService) ValidateSession(sessionID string) (*models.CarCreationSession, error) {
	var session models.CarCreationSession
	if err := s.db.First(&session, "id = ?", sessionID).Error; err != nil {
		return nil, err
	}

	if time.Now().After(session.ExpiresAt) {
		return nil, errors.New("session expired")
	}

	return &session, nil
}

// SaveBasicDetails saves the basic details of the car
func (s *CarCreationService) SaveBasicDetails(sessionID string, details models.BasicDetailsStep) (*models.StepResponse, error) {
	session, err := s.ValidateSession(sessionID)
	if err != nil {
		return nil, err
	}

	if session.State != models.BasicDetails {
		return nil, errors.New("invalid step")
	}

	// Start a transaction
	tx := s.db.Begin()

	// Create car with basic details
	car := &models.Car{
		ID:                session.CarID,
		Make:              details.Make,
		Model:             details.Model,
		Year:              details.Year,
		Variant:           details.Variant,
		FuelType:          details.FuelType,
		Transmission:      details.Transmission,
		BodyType:          details.BodyType,
		Color:             details.Color,
		SeatingCapacity:   details.SeatingCapacity,
		VehicleNumber:     details.VehicleNumber,
		RegistrationState: details.RegistrationState,
	}

	if err := tx.Create(car).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// Update session state
	session.State = models.OwnerInfo
	if err := tx.Save(session).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if err := tx.Commit().Error; err != nil {
		return nil, err
	}

	return &models.StepResponse{
		SessionID:   session.ID.String(),
		CarID:       car.ID.String(),
		CurrentStep: models.BasicDetails,
		NextStep:    models.OwnerInfo,
		Message:     "Basic details saved successfully",
	}, nil
}

// SaveOwnerInfo saves the owner information
func (s *CarCreationService) SaveOwnerInfo(sessionID string, ownerInfo models.OwnerInfoStep) (*models.StepResponse, error) {
	session, err := s.ValidateSession(sessionID)
	if err != nil {
		return nil, err
	}

	if session.State != models.OwnerInfo {
		return nil, errors.New("invalid step")
	}

	tx := s.db.Begin()

	// Create owner
	owner := &models.Owner{
		Name:        ownerInfo.Name,
		ContactInfo: ownerInfo.ContactInfo,
	}

	if err := tx.Create(owner).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// Update car with owner ID
	if err := tx.Model(&models.Car{}).Where("id = ?", session.CarID).Update("owner_id", owner.ID).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// Update session state
	session.State = models.LocationDetails
	if err := tx.Save(session).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if err := tx.Commit().Error; err != nil {
		return nil, err
	}

	return &models.StepResponse{
		SessionID:   session.ID.String(),
		CarID:       session.CarID.String(),
		CurrentStep: models.OwnerInfo,
		NextStep:    models.LocationDetails,
		Message:     "Owner information saved successfully",
	}, nil
}

// SaveLocationDetails saves the location details
func (s *CarCreationService) SaveLocationDetails(sessionID string, location models.LocationDetailsStep) (*models.StepResponse, error) {
	session, err := s.ValidateSession(sessionID)
	if err != nil {
		return nil, err
	}

	if session.State != models.LocationDetails {
		return nil, errors.New("invalid step")
	}

	tx := s.db.Begin()

	carLocation := &models.CarLocation{
		CarID:             session.CarID,
		CurrentLocation:   location.CurrentLocation,
		AvailableBranches: location.AvailableBranches,
	}

	if err := tx.Create(carLocation).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// Update session state
	session.State = models.RentalInfo
	if err := tx.Save(session).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if err := tx.Commit().Error; err != nil {
		return nil, err
	}

	return &models.StepResponse{
		SessionID:   session.ID.String(),
		CarID:       session.CarID.String(),
		CurrentStep: models.LocationDetails,
		NextStep:    models.RentalInfo,
		Message:     "Location details saved successfully",
	}, nil
}

// SaveRentalInfo saves the rental information
func (s *CarCreationService) SaveRentalInfo(sessionID string, rentalInfo models.RentalInfoStep) (*models.StepResponse, error) {
	session, err := s.ValidateSession(sessionID)
	if err != nil {
		return nil, err
	}

	if session.State != models.RentalInfo {
		return nil, errors.New("invalid step")
	}

	tx := s.db.Begin()

	carRentalInfo := &models.CarRentalInfo{
		CarID:               session.CarID,
		RentalPricePerDay:   rentalInfo.RentalPricePerDay,
		RentalPricePerHour:  rentalInfo.RentalPricePerHour,
		MinimumRentDuration: rentalInfo.MinimumRentDuration,
		MaximumRentDuration: rentalInfo.MaximumRentDuration,
		SecurityDeposit:     rentalInfo.SecurityDeposit,
		LateFeePerHour:      rentalInfo.LateFeePerHour,
		Discounts:           rentalInfo.Discounts,
	}

	if err := tx.Create(carRentalInfo).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// Update session state
	session.State = models.DocumentsMedia
	if err := tx.Save(session).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if err := tx.Commit().Error; err != nil {
		return nil, err
	}

	return &models.StepResponse{
		SessionID:   session.ID.String(),
		CarID:       session.CarID.String(),
		CurrentStep: models.RentalInfo,
		NextStep:    models.DocumentsMedia,
		Message:     "Rental information saved successfully",
	}, nil
}

// SaveDocumentsMedia saves the documents and media information
func (s *CarCreationService) SaveDocumentsMedia(sessionID string, docsMedia models.DocumentsMediaStep) (*models.StepResponse, error) {
	session, err := s.ValidateSession(sessionID)
	if err != nil {
		return nil, err
	}

	if session.State != models.DocumentsMedia {
		return nil, errors.New("invalid step")
	}

	tx := s.db.Begin()

	// Save documents
	for _, doc := range docsMedia.Documents {
		doc.CarID = session.CarID
		if err := tx.Create(&doc).Error; err != nil {
			tx.Rollback()
			return nil, err
		}
	}

	// Save media
	for _, media := range docsMedia.Media {
		media.CarID = session.CarID
		if err := tx.Create(&media).Error; err != nil {
			tx.Rollback()
			return nil, err
		}
	}

	// Update session state
	session.State = models.StatusInfo
	if err := tx.Save(session).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if err := tx.Commit().Error; err != nil {
		return nil, err
	}

	return &models.StepResponse{
		SessionID:   session.ID.String(),
		CarID:       session.CarID.String(),
		CurrentStep: models.DocumentsMedia,
		NextStep:    models.StatusInfo,
		Message:     "Documents and media saved successfully",
	}, nil
}

// SaveStatusInfo saves the status and maintenance information
func (s *CarCreationService) SaveStatusInfo(sessionID string, status models.StatusInfoStep) (*models.StepResponse, error) {
	session, err := s.ValidateSession(sessionID)
	if err != nil {
		return nil, err
	}

	if session.State != models.StatusInfo {
		return nil, errors.New("invalid step")
	}

	tx := s.db.Begin()

	carStatus := &models.CarStatus{
		CarID:                  session.CarID,
		IsAvailable:            status.IsAvailable,
		CurrentOdometerReading: status.CurrentOdometerReading,
		LastServiceDate:        status.LastServiceDate,
		NextServiceDue:         status.NextServiceDue,
		DamagesOrIssues:        status.DamagesOrIssues,
	}

	if err := tx.Create(carStatus).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	// Update session state
	session.State = models.Completed
	if err := tx.Save(session).Error; err != nil {
		tx.Rollback()
		return nil, err
	}

	if err := tx.Commit().Error; err != nil {
		return nil, err
	}

	return &models.StepResponse{
		SessionID:   session.ID.String(),
		CarID:       session.CarID.String(),
		CurrentStep: models.StatusInfo,
		NextStep:    models.Completed,
		Message:     "Status information saved successfully",
	}, nil
}

// GetCarCreationProgress retrieves the current progress of car creation
func (s *CarCreationService) GetCarCreationProgress(sessionID string) (*models.StepResponse, error) {
	session, err := s.ValidateSession(sessionID)
	if err != nil {
		return nil, err
	}

	var nextStep models.CarCreationState
	switch session.State {
	case models.BasicDetails:
		nextStep = models.OwnerInfo
	case models.OwnerInfo:
		nextStep = models.LocationDetails
	case models.LocationDetails:
		nextStep = models.RentalInfo
	case models.RentalInfo:
		nextStep = models.DocumentsMedia
	case models.DocumentsMedia:
		nextStep = models.StatusInfo
	case models.StatusInfo:
		nextStep = models.Completed
	case models.Completed:
		nextStep = models.Completed
	}

	return &models.StepResponse{
		SessionID:   session.ID.String(),
		CarID:       session.CarID.String(),
		CurrentStep: session.State,
		NextStep:    nextStep,
		Message:     "Current progress retrieved successfully",
	}, nil
}
