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
DO $$
BEGIN
    -- Check if columns exist before trying to drop them
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'current_location') THEN
        ALTER TABLE cars DROP COLUMN current_location CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'available_branches') THEN
        ALTER TABLE cars DROP COLUMN available_branches CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'rental_price_per_day') THEN
        ALTER TABLE cars DROP COLUMN rental_price_per_day CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'rental_price_per_hour') THEN
        ALTER TABLE cars DROP COLUMN rental_price_per_hour CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'minimum_rent_duration') THEN
        ALTER TABLE cars DROP COLUMN minimum_rent_duration CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'maximum_rent_duration') THEN
        ALTER TABLE cars DROP COLUMN maximum_rent_duration CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'security_deposit') THEN
        ALTER TABLE cars DROP COLUMN security_deposit CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'late_fee_per_hour') THEN
        ALTER TABLE cars DROP COLUMN late_fee_per_hour CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'discounts') THEN
        ALTER TABLE cars DROP COLUMN discounts CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'images') THEN
        ALTER TABLE cars DROP COLUMN images CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'video') THEN
        ALTER TABLE cars DROP COLUMN video CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'insurance_expiry_date') THEN
        ALTER TABLE cars DROP COLUMN insurance_expiry_date CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'pollution_certificate_validity') THEN
        ALTER TABLE cars DROP COLUMN pollution_certificate_validity CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'registration_certificate') THEN
        ALTER TABLE cars DROP COLUMN registration_certificate CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'fitness_certificate') THEN
        ALTER TABLE cars DROP COLUMN fitness_certificate CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'permit_type') THEN
        ALTER TABLE cars DROP COLUMN permit_type CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'is_available') THEN
        ALTER TABLE cars DROP COLUMN is_available CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'current_odometer_reading') THEN
        ALTER TABLE cars DROP COLUMN current_odometer_reading CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'last_service_date') THEN
        ALTER TABLE cars DROP COLUMN last_service_date CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'next_service_due') THEN
        ALTER TABLE cars DROP COLUMN next_service_due CASCADE;
    END IF;
    
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'cars' AND column_name = 'damages_or_issues') THEN
        ALTER TABLE cars DROP COLUMN damages_or_issues CASCADE;
    END IF;
END $$;

-- Create migration to populate new tables from existing data
DO $$
DECLARE
    car_rec RECORD;
    column_exists BOOLEAN;
BEGIN
    -- Check if we need to migrate data (only if cars has data and related tables are empty)
    PERFORM 1 FROM cars LIMIT 1;
    IF FOUND THEN
        -- Check if owner_name column exists in cars table
        SELECT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'cars' AND column_name = 'owner_name'
        ) INTO column_exists;
        
        -- Only migrate owner data if we have the owner_name column
        IF column_exists THEN
            -- Check if owners table is empty
            PERFORM 1 FROM owners LIMIT 1;
            IF NOT FOUND THEN
                -- Migrate owner data
                INSERT INTO owners (id, name, contact_info, created_at, updated_at)
                SELECT DISTINCT owner_id, owner_name, contact_info, created_at, updated_at 
                FROM cars 
                WHERE owner_id IS NOT NULL AND owner_name IS NOT NULL
                ON CONFLICT (id) DO NOTHING;
            END IF;
        END IF;
        
        -- Check if we have any of the columns needed for migration
        SELECT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'cars' AND column_name = 'current_location'
        ) INTO column_exists;
        
        -- Only proceed with detailed migration if we have the columns to migrate
        IF column_exists THEN
            -- For each car, create related records only if they don't exist yet
            FOR car_rec IN SELECT * FROM cars LOOP
                -- Check if car_location already exists
                PERFORM 1 FROM car_locations WHERE car_id = car_rec.id LIMIT 1;
                IF NOT FOUND THEN
                    -- Insert car_location
                    INSERT INTO car_locations (car_id, current_location, available_branches)
                    VALUES (car_rec.id, car_rec.current_location, COALESCE(car_rec.available_branches, '[]'::jsonb));
                END IF;
                
                -- Check if car_rental_info already exists
                PERFORM 1 FROM car_rental_infos WHERE car_id = car_rec.id LIMIT 1;
                IF NOT FOUND THEN
                    -- Insert car_rental_info
                    INSERT INTO car_rental_infos (
                        car_id, rental_price_per_day, rental_price_per_hour, 
                        minimum_rent_duration, maximum_rent_duration, 
                        security_deposit, late_fee_per_hour, discounts
                    )
                    VALUES (
                        car_rec.id, 
                        COALESCE(car_rec.rental_price_per_day, 0), 
                        car_rec.rental_price_per_hour,
                        COALESCE(car_rec.minimum_rent_duration, 1), 
                        COALESCE(car_rec.maximum_rent_duration, 30),
                        COALESCE(car_rec.security_deposit, 0), 
                        COALESCE(car_rec.late_fee_per_hour, 0), 
                        car_rec.discounts
                    );
                END IF;
                
                -- Check if car has images
                IF car_rec.images IS NOT NULL AND car_rec.images::text <> '[]'::text THEN
                    -- Check if car already has media
                    PERFORM 1 FROM car_media WHERE car_id = car_rec.id AND type = 'image' LIMIT 1;
                    IF NOT FOUND THEN
                        -- Insert car_media for images
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
                END IF;
                
                -- Check if car has video and doesn't already have video in car_media
                IF car_rec.video IS NOT NULL THEN
                    PERFORM 1 FROM car_media WHERE car_id = car_rec.id AND type = 'video' LIMIT 1;
                    IF NOT FOUND THEN
                        -- Insert car_media for video
                        INSERT INTO car_media (car_id, type, url)
                        VALUES (car_rec.id, 'video', car_rec.video);
                    END IF;
                END IF;
                
                -- Check if car already has documents
                PERFORM 1 FROM car_documents WHERE car_id = car_rec.id LIMIT 1;
                IF NOT FOUND THEN
                    -- Insert car documents
                    INSERT INTO car_documents (
                        car_id, document_type, expiry_date, document_path, permit_type
                    )
                    VALUES
                    (car_rec.id, 'insurance', car_rec.insurance_expiry_date, 'insurance_cert_' || car_rec.id, car_rec.permit_type),
                    (car_rec.id, 'pollution', car_rec.pollution_certificate_validity, car_rec.registration_certificate, car_rec.permit_type),
                    (car_rec.id, 'registration', NULL, car_rec.registration_certificate, car_rec.permit_type),
                    (car_rec.id, 'fitness', NULL, car_rec.fitness_certificate, car_rec.permit_type);
                END IF;
                
                -- Check if car already has status
                PERFORM 1 FROM car_statuses WHERE car_id = car_rec.id LIMIT 1;
                IF NOT FOUND THEN
                    -- Insert car status
                    INSERT INTO car_statuses (
                        car_id, is_available, current_odometer_reading,
                        last_service_date, next_service_due, damages_or_issues
                    )
                    VALUES (
                        car_rec.id, 
                        COALESCE(car_rec.is_available, true), 
                        COALESCE(car_rec.current_odometer_reading, 0),
                        COALESCE(car_rec.last_service_date, CURRENT_DATE), 
                        COALESCE(car_rec.next_service_due, CURRENT_DATE + INTERVAL '1 year'),
                        car_rec.damages_or_issues
                    );
                END IF;
            END LOOP;
        END IF;
    END IF;
END $$;

-- Create indexes for efficient querying - using IF NOT EXISTS to avoid errors
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_car_locations_car_id') THEN
        CREATE INDEX idx_car_locations_car_id ON car_locations(car_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_car_rental_infos_car_id') THEN
        CREATE INDEX idx_car_rental_infos_car_id ON car_rental_infos(car_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_car_media_car_id') THEN
        CREATE INDEX idx_car_media_car_id ON car_media(car_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_car_documents_car_id') THEN
        CREATE INDEX idx_car_documents_car_id ON car_documents(car_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_car_statuses_car_id') THEN
        CREATE INDEX idx_car_statuses_car_id ON car_statuses(car_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_car_statuses_is_available') THEN
        CREATE INDEX idx_car_statuses_is_available ON car_statuses(is_available);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_cars_owner_id') THEN
        CREATE INDEX idx_cars_owner_id ON cars(owner_id);
    END IF;
END $$;

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