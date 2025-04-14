-- Create owners table
CREATE TABLE IF NOT EXISTS owners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(255) NOT NULL
);

-- Create car_locations table
CREATE TABLE IF NOT EXISTS car_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    
    car_id UUID NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
    current_location VARCHAR(255) NOT NULL,
    available_branches JSONB NOT NULL DEFAULT '[]'
);

-- Create car_rental_infos table
CREATE TABLE IF NOT EXISTS car_rental_infos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    
    car_id UUID NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
    rental_price_per_day DECIMAL(10,2) NOT NULL CHECK (rental_price_per_day >= 0),
    rental_price_per_hour DECIMAL(10,2),
    minimum_rent_duration INTEGER NOT NULL CHECK (minimum_rent_duration > 0),
    maximum_rent_duration INTEGER NOT NULL CHECK (maximum_rent_duration > 0),
    security_deposit DECIMAL(10,2) NOT NULL CHECK (security_deposit >= 0),
    late_fee_per_hour DECIMAL(10,2) NOT NULL CHECK (late_fee_per_hour >= 0),
    discounts JSONB,
    
    CONSTRAINT valid_rent_duration CHECK (maximum_rent_duration >= minimum_rent_duration)
);

-- Create car_media table
CREATE TABLE IF NOT EXISTS car_media (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    
    car_id UUID NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
    type VARCHAR(20) NOT NULL,
    url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT false
);

-- Create car_documents table
CREATE TABLE IF NOT EXISTS car_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    
    car_id UUID NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
    document_type VARCHAR(50) NOT NULL,
    expiry_date DATE,
    document_path VARCHAR(255) NOT NULL,
    permit_type VARCHAR(20)
);

-- Create car_statuses table
CREATE TABLE IF NOT EXISTS car_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    
    car_id UUID NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
    is_available BOOLEAN NOT NULL DEFAULT true,
    current_odometer_reading DECIMAL(10,2) NOT NULL CHECK (current_odometer_reading >= 0),
    last_service_date DATE NOT NULL,
    next_service_due DATE NOT NULL,
    damages_or_issues TEXT,
    
    CONSTRAINT valid_service_dates CHECK (next_service_due > last_service_date)
);

-- Modify cars table to reference owner instead of embedding
ALTER TABLE cars 
    -- Drop embedded columns
    DROP COLUMN IF EXISTS current_location CASCADE,
    DROP COLUMN IF EXISTS available_branches CASCADE,
    DROP COLUMN IF EXISTS rental_price_per_day CASCADE,
    DROP COLUMN IF EXISTS rental_price_per_hour CASCADE,
    DROP COLUMN IF EXISTS minimum_rent_duration CASCADE,
    DROP COLUMN IF EXISTS maximum_rent_duration CASCADE,
    DROP COLUMN IF EXISTS security_deposit CASCADE,
    DROP COLUMN IF EXISTS late_fee_per_hour CASCADE,
    DROP COLUMN IF EXISTS discounts CASCADE,
    DROP COLUMN IF EXISTS images CASCADE,
    DROP COLUMN IF EXISTS video CASCADE,
    DROP COLUMN IF EXISTS insurance_expiry_date CASCADE,
    DROP COLUMN IF EXISTS pollution_certificate_validity CASCADE,
    DROP COLUMN IF EXISTS registration_certificate CASCADE,
    DROP COLUMN IF EXISTS fitness_certificate CASCADE,
    DROP COLUMN IF EXISTS permit_type CASCADE,
    DROP COLUMN IF EXISTS is_available CASCADE,
    DROP COLUMN IF EXISTS current_odometer_reading CASCADE,
    DROP COLUMN IF EXISTS last_service_date CASCADE,
    DROP COLUMN IF EXISTS next_service_due CASCADE,
    DROP COLUMN IF EXISTS damages_or_issues CASCADE;

-- Create migration to populate new tables from existing data
DO $$
DECLARE
    car_rec RECORD;
BEGIN
    -- Migrate owner data
    INSERT INTO owners (id, name, contact_info, created_at, updated_at)
    SELECT DISTINCT owner_id, owner_name, contact_info, created_at, updated_at FROM cars;

    -- For each car, create related records
    FOR car_rec IN SELECT * FROM cars LOOP
        -- Insert car_location
        INSERT INTO car_locations (car_id, current_location, available_branches)
        VALUES (car_rec.id, car_rec.current_location, car_rec.available_branches);
        
        -- Insert car_rental_info
        INSERT INTO car_rental_infos (
            car_id, rental_price_per_day, rental_price_per_hour, 
            minimum_rent_duration, maximum_rent_duration, 
            security_deposit, late_fee_per_hour, discounts
        )
        VALUES (
            car_rec.id, car_rec.rental_price_per_day, car_rec.rental_price_per_hour,
            car_rec.minimum_rent_duration, car_rec.maximum_rent_duration,
            car_rec.security_deposit, car_rec.late_fee_per_hour, car_rec.discounts
        );
        
        -- Insert car_media for images
        IF car_rec.images IS NOT NULL AND car_rec.images::text <> '[]'::text THEN
            FOR i IN 0..jsonb_array_length(car_rec.images)-1 LOOP
                INSERT INTO car_media (car_id, type, url, is_primary)
                VALUES (
                    car_rec.id, 
                    'image', 
                    jsonb_array_element_text(car_rec.images, i),
                    i = 0  -- First image is primary
                );
            END LOOP;
        END IF;
        
        -- Insert car_media for video
        IF car_rec.video IS NOT NULL THEN
            INSERT INTO car_media (car_id, type, url)
            VALUES (car_rec.id, 'video', car_rec.video);
        END IF;
        
        -- Insert car documents
        INSERT INTO car_documents (
            car_id, document_type, expiry_date, document_path, permit_type
        )
        VALUES
        (car_rec.id, 'insurance', car_rec.insurance_expiry_date, 'insurance_cert_' || car_rec.id, car_rec.permit_type),
        (car_rec.id, 'pollution', car_rec.pollution_certificate_validity, car_rec.registration_certificate, car_rec.permit_type),
        (car_rec.id, 'registration', NULL, car_rec.registration_certificate, car_rec.permit_type),
        (car_rec.id, 'fitness', NULL, car_rec.fitness_certificate, car_rec.permit_type);
        
        -- Insert car status
        INSERT INTO car_statuses (
            car_id, is_available, current_odometer_reading,
            last_service_date, next_service_due, damages_or_issues
        )
        VALUES (
            car_rec.id, car_rec.is_available, car_rec.current_odometer_reading,
            car_rec.last_service_date, car_rec.next_service_due, car_rec.damages_or_issues
        );
    END LOOP;
END $$;

-- Create indexes for efficient querying
CREATE INDEX idx_car_locations_car_id ON car_locations(car_id);
CREATE INDEX idx_car_rental_infos_car_id ON car_rental_infos(car_id);
CREATE INDEX idx_car_media_car_id ON car_media(car_id);
CREATE INDEX idx_car_documents_car_id ON car_documents(car_id);
CREATE INDEX idx_car_statuses_car_id ON car_statuses(car_id);
CREATE INDEX idx_car_statuses_is_available ON car_statuses(is_available);
CREATE INDEX idx_cars_owner_id ON cars(owner_id);

-- Create trigger for updated_at on all tables
DO $$
BEGIN
    -- For owners
    DROP TRIGGER IF EXISTS update_owners_updated_at ON owners;
    CREATE TRIGGER update_owners_updated_at
        BEFORE UPDATE ON owners
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    
    -- For car_locations
    DROP TRIGGER IF EXISTS update_car_locations_updated_at ON car_locations;
    CREATE TRIGGER update_car_locations_updated_at
        BEFORE UPDATE ON car_locations
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    
    -- For car_rental_infos
    DROP TRIGGER IF EXISTS update_car_rental_infos_updated_at ON car_rental_infos;
    CREATE TRIGGER update_car_rental_infos_updated_at
        BEFORE UPDATE ON car_rental_infos
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    
    -- For car_media
    DROP TRIGGER IF EXISTS update_car_media_updated_at ON car_media;
    CREATE TRIGGER update_car_media_updated_at
        BEFORE UPDATE ON car_media
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    
    -- For car_documents
    DROP TRIGGER IF EXISTS update_car_documents_updated_at ON car_documents;
    CREATE TRIGGER update_car_documents_updated_at
        BEFORE UPDATE ON car_documents
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    
    -- For car_statuses
    DROP TRIGGER IF EXISTS update_car_statuses_updated_at ON car_statuses;
    CREATE TRIGGER update_car_statuses_updated_at
        BEFORE UPDATE ON car_statuses
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
END $$; 