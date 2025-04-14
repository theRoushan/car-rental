package database

import (
	"car-rental-backend/config"
	"car-rental-backend/models"
	"fmt"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func InitDB(cfg *config.Config) error {
	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		cfg.DBHost,
		cfg.DBPort,
		cfg.DBUser,
		cfg.DBPassword,
		cfg.DBName,
		cfg.DBSSLMode,
	)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		return fmt.Errorf("failed to connect to database: %v", err)
	}

	// Auto Migrate the schema
	err = db.AutoMigrate(
		&models.User{},
		&models.Car{},
		&models.Booking{},
		&models.Owner{},
		&models.CarLocation{},
		&models.CarRentalInfo{},
		&models.CarMedia{},
		&models.CarDocument{},
		&models.CarStatus{},
	)
	if err != nil {
		return fmt.Errorf("failed to migrate database: %v", err)
	}

	DB = db
	return nil
}

func GetDB() *gorm.DB {
	return DB
}
