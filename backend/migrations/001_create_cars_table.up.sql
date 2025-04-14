-- Create enum types if they don't exist
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
    
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'permit_type') THEN
        CREATE TYPE permit_type AS ENUM ('Self-drive', 'Commercial');
    END IF;
END$$;

-- Create base table for common fields if it doesn't exist
CREATE TABLE IF NOT EXISTS base (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Drop existing cars table and its dependencies if they exist
DO $$
BEGIN
    -- Drop dependent triggers
    DROP TRIGGER IF EXISTS update_cars_updated_at ON cars;
    
    -- Drop dependent indexes
    DROP INDEX IF EXISTS idx_cars_vehicle_number;
    DROP INDEX IF EXISTS idx_cars_is_available;
    DROP INDEX IF EXISTS idx_cars_location;
    DROP INDEX IF EXISTS idx_cars_owner;
    
    -- Drop the table
    DROP TABLE IF EXISTS cars CASCADE;
END$$;

-- Create cars table
CREATE TABLE cars (
    -- Inherit from base
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,

    -- Basic Car Details
    make VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL CHECK (year >= 1900 AND year <= EXTRACT(YEAR FROM CURRENT_DATE)),
    variant VARCHAR(100) NOT NULL,
    fuel_type VARCHAR(20) NOT NULL,
    transmission VARCHAR(20) NOT NULL,
    body_type VARCHAR(20) NOT NULL,
    color VARCHAR(50) NOT NULL,
    seating_capacity INTEGER NOT NULL CHECK (seating_capacity > 0 AND seating_capacity <= 50),
    vehicle_number VARCHAR(20) NOT NULL UNIQUE,
    registration_state VARCHAR(100) NOT NULL,

    -- Location Info
    current_location VARCHAR(255) NOT NULL,
    available_branches JSONB NOT NULL DEFAULT '[]',

    -- Rental Info
    rental_price_per_day DECIMAL(10,2) NOT NULL CHECK (rental_price_per_day >= 0),
    rental_price_per_hour DECIMAL(10,2),
    minimum_rent_duration INTEGER NOT NULL CHECK (minimum_rent_duration > 0),
    maximum_rent_duration INTEGER NOT NULL CHECK (maximum_rent_duration > 0),
    security_deposit DECIMAL(10,2) NOT NULL CHECK (security_deposit >= 0),
    late_fee_per_hour DECIMAL(10,2) NOT NULL CHECK (late_fee_per_hour >= 0),
    discounts JSONB,

    -- Media
    images JSONB NOT NULL DEFAULT '[]',
    video VARCHAR(255),

    -- Documentation
    insurance_expiry_date DATE NOT NULL,
    pollution_certificate_validity DATE NOT NULL,
    registration_certificate VARCHAR(255) NOT NULL,
    fitness_certificate VARCHAR(255) NOT NULL,
    permit_type VARCHAR(20) NOT NULL,

    -- Status Info
    is_available BOOLEAN NOT NULL DEFAULT true,
    current_odometer_reading DECIMAL(10,2) NOT NULL CHECK (current_odometer_reading >= 0),
    last_service_date DATE NOT NULL,
    next_service_due DATE NOT NULL,
    damages_or_issues TEXT,

    -- Owner Info
    owner_id UUID NOT NULL,
    owner_name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(255) NOT NULL,

    -- Constraints
    CONSTRAINT valid_rent_duration CHECK (maximum_rent_duration >= minimum_rent_duration),
    CONSTRAINT valid_service_dates CHECK (next_service_due > last_service_date)
);

-- Create indexes
CREATE INDEX idx_cars_vehicle_number ON cars(vehicle_number);
CREATE INDEX idx_cars_is_available ON cars(is_available);
CREATE INDEX idx_cars_location ON cars(current_location);
CREATE INDEX idx_cars_owner ON cars(owner_id);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_cars_updated_at
    BEFORE UPDATE ON cars
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 