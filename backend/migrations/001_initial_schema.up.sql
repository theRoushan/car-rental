-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create enums
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'fuel_type') THEN
        CREATE TYPE fuel_type AS ENUM ('Petrol', 'Diesel', 'Electric', 'Hybrid');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'transmission_type') THEN
        CREATE TYPE transmission_type AS ENUM ('Manual', 'Automatic', 'CVT');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'body_type') THEN
        CREATE TYPE body_type AS ENUM ('Sedan', 'SUV', 'Hatchback', 'Coupe', 'Van', 'Truck');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'booking_status') THEN
        CREATE TYPE booking_status AS ENUM ('BOOKED', 'CANCELLED', 'COMPLETED');
    END IF;
END$$;

-- Add updated_at timestamp function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create owners table
CREATE TABLE IF NOT EXISTS owners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create cars table
CREATE TABLE IF NOT EXISTS cars (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    make VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL,
    variant VARCHAR(100) NOT NULL,
    fuel_type VARCHAR(20) NOT NULL,
    transmission VARCHAR(20) NOT NULL,
    body_type VARCHAR(20) NOT NULL,
    color VARCHAR(50) NOT NULL,
    seating_capacity INTEGER NOT NULL,
    vehicle_number VARCHAR(50) NOT NULL,
    owner_id UUID NOT NULL REFERENCES owners(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT check_car_fuel_type CHECK (fuel_type IN ('Petrol', 'Diesel', 'Electric', 'Hybrid')),
    CONSTRAINT check_car_transmission CHECK (transmission IN ('Manual', 'Automatic', 'CVT')),
    CONSTRAINT check_car_body_type CHECK (body_type IN ('Sedan', 'SUV', 'Hatchback', 'Coupe', 'Van', 'Truck'))
);

-- Create unique index on vehicle_number if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_indexes 
        WHERE indexname = 'idx_cars_vehicle_number'
    ) THEN
        CREATE UNIQUE INDEX idx_cars_vehicle_number ON cars(vehicle_number) WHERE deleted_at IS NULL;
    END IF;
END$$;

-- Create car_rental_infos table
CREATE TABLE IF NOT EXISTS car_rental_infos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    car_id UUID NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
    rental_price_per_day DECIMAL(10,2) NOT NULL CHECK (rental_price_per_day >= 0),
    rental_price_per_hour DECIMAL(10,2) NOT NULL CHECK (rental_price_per_hour >= 0),
    minimum_rent_duration INTEGER NOT NULL CHECK (minimum_rent_duration > 0),
    security_deposit DECIMAL(10,2) NOT NULL CHECK (security_deposit >= 0),
    late_fee_per_hour DECIMAL(10,2) NOT NULL CHECK (late_fee_per_hour >= 0),
    rental_extend_fee_per_day DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (rental_extend_fee_per_day >= 0),
    rental_extend_fee_per_hour DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (rental_extend_fee_per_hour >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create car_media table
CREATE TABLE IF NOT EXISTS car_media (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    car_id UUID NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
    type VARCHAR(20) NOT NULL,
    url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create car_statuses table
CREATE TABLE IF NOT EXISTS car_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    car_id UUID NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
    is_available BOOLEAN NOT NULL DEFAULT true,
    current_odometer_reading DECIMAL(10,2) NOT NULL CHECK (current_odometer_reading >= 0),
    damages_or_issues JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    car_id UUID NOT NULL REFERENCES cars(id),
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE NOT NULL,
    status VARCHAR(20) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT check_booking_status CHECK (status IN ('BOOKED', 'CANCELLED', 'COMPLETED')),
    CONSTRAINT check_booking_times CHECK (end_time > start_time)
);

-- Create indexes for better query performance
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_car_rental_infos_car_id') THEN
        CREATE INDEX idx_car_rental_infos_car_id ON car_rental_infos(car_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_car_media_car_id') THEN
        CREATE INDEX idx_car_media_car_id ON car_media(car_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_car_statuses_car_id') THEN
        CREATE INDEX idx_car_statuses_car_id ON car_statuses(car_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_bookings_user_id') THEN
        CREATE INDEX idx_bookings_user_id ON bookings(user_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_bookings_car_id') THEN
        CREATE INDEX idx_bookings_car_id ON bookings(car_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_bookings_status') THEN
        CREATE INDEX idx_bookings_status ON bookings(status);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_cars_owner_id') THEN
        CREATE INDEX idx_cars_owner_id ON cars(owner_id);
    END IF;
END$$;

-- Create triggers to automatically update timestamps
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_users_updated_at') THEN
        CREATE TRIGGER update_users_updated_at
        BEFORE UPDATE ON users
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_owners_updated_at') THEN
        CREATE TRIGGER update_owners_updated_at
        BEFORE UPDATE ON owners
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_cars_updated_at') THEN
        CREATE TRIGGER update_cars_updated_at
        BEFORE UPDATE ON cars
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_car_rental_infos_updated_at') THEN
        CREATE TRIGGER update_car_rental_infos_updated_at
        BEFORE UPDATE ON car_rental_infos
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_car_media_updated_at') THEN
        CREATE TRIGGER update_car_media_updated_at
        BEFORE UPDATE ON car_media
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_car_statuses_updated_at') THEN
        CREATE TRIGGER update_car_statuses_updated_at
        BEFORE UPDATE ON car_statuses
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_bookings_updated_at') THEN
        CREATE TRIGGER update_bookings_updated_at
        BEFORE UPDATE ON bookings
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    END IF;
END$$; 