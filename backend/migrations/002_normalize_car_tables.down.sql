-- Add back the columns to cars table
ALTER TABLE cars ADD COLUMN IF NOT EXISTS current_location VARCHAR(255);
ALTER TABLE cars ADD COLUMN IF NOT EXISTS available_branches JSONB DEFAULT '[]';
ALTER TABLE cars ADD COLUMN IF NOT EXISTS rental_price_per_day DECIMAL(10,2);
ALTER TABLE cars ADD COLUMN IF NOT EXISTS rental_price_per_hour DECIMAL(10,2);
ALTER TABLE cars ADD COLUMN IF NOT EXISTS minimum_rent_duration INTEGER;
ALTER TABLE cars ADD COLUMN IF NOT EXISTS maximum_rent_duration INTEGER;
ALTER TABLE cars ADD COLUMN IF NOT EXISTS security_deposit DECIMAL(10,2);
ALTER TABLE cars ADD COLUMN IF NOT EXISTS late_fee_per_hour DECIMAL(10,2);
ALTER TABLE cars ADD COLUMN IF NOT EXISTS discounts JSONB;
ALTER TABLE cars ADD COLUMN IF NOT EXISTS images JSONB DEFAULT '[]';
ALTER TABLE cars ADD COLUMN IF NOT EXISTS video VARCHAR(255);
ALTER TABLE cars ADD COLUMN IF NOT EXISTS insurance_expiry_date DATE;
ALTER TABLE cars ADD COLUMN IF NOT EXISTS pollution_certificate_validity DATE;
ALTER TABLE cars ADD COLUMN IF NOT EXISTS registration_certificate VARCHAR(255);
ALTER TABLE cars ADD COLUMN IF NOT EXISTS fitness_certificate VARCHAR(255);
ALTER TABLE cars ADD COLUMN IF NOT EXISTS permit_type VARCHAR(20);
ALTER TABLE cars ADD COLUMN IF NOT EXISTS is_available BOOLEAN DEFAULT true;
ALTER TABLE cars ADD COLUMN IF NOT EXISTS current_odometer_reading DECIMAL(10,2);
ALTER TABLE cars ADD COLUMN IF NOT EXISTS last_service_date DATE;
ALTER TABLE cars ADD COLUMN IF NOT EXISTS next_service_due DATE;
ALTER TABLE cars ADD COLUMN IF NOT EXISTS damages_or_issues TEXT;

-- Copy data back from normalized tables to the cars table
DO $$
DECLARE
    car_rec RECORD;
BEGIN
    FOR car_rec IN SELECT * FROM cars LOOP
        -- Update from car_locations
        UPDATE cars
        SET current_location = (SELECT current_location FROM car_locations WHERE car_id = car_rec.id LIMIT 1),
            available_branches = (SELECT available_branches FROM car_locations WHERE car_id = car_rec.id LIMIT 1)
        WHERE id = car_rec.id;
        
        -- Update from car_rental_infos
        UPDATE cars
        SET rental_price_per_day = (SELECT rental_price_per_day FROM car_rental_infos WHERE car_id = car_rec.id LIMIT 1),
            rental_price_per_hour = (SELECT rental_price_per_hour FROM car_rental_infos WHERE car_id = car_rec.id LIMIT 1),
            minimum_rent_duration = (SELECT minimum_rent_duration FROM car_rental_infos WHERE car_id = car_rec.id LIMIT 1),
            maximum_rent_duration = (SELECT maximum_rent_duration FROM car_rental_infos WHERE car_id = car_rec.id LIMIT 1),
            security_deposit = (SELECT security_deposit FROM car_rental_infos WHERE car_id = car_rec.id LIMIT 1),
            late_fee_per_hour = (SELECT late_fee_per_hour FROM car_rental_infos WHERE car_id = car_rec.id LIMIT 1),
            discounts = (SELECT discounts FROM car_rental_infos WHERE car_id = car_rec.id LIMIT 1)
        WHERE id = car_rec.id;
        
        -- Update from car_media
        UPDATE cars
        SET images = (
            SELECT jsonb_agg(url)
            FROM car_media
            WHERE car_id = car_rec.id AND type = 'image'
        ),
        video = (
            SELECT url
            FROM car_media
            WHERE car_id = car_rec.id AND type = 'video'
            LIMIT 1
        )
        WHERE id = car_rec.id;
        
        -- Update from car_documents
        UPDATE cars
        SET insurance_expiry_date = (
                SELECT expiry_date
                FROM car_documents
                WHERE car_id = car_rec.id AND document_type = 'insurance'
                LIMIT 1
            ),
            pollution_certificate_validity = (
                SELECT expiry_date
                FROM car_documents
                WHERE car_id = car_rec.id AND document_type = 'pollution'
                LIMIT 1
            ),
            registration_certificate = (
                SELECT document_path
                FROM car_documents
                WHERE car_id = car_rec.id AND document_type = 'registration'
                LIMIT 1
            ),
            fitness_certificate = (
                SELECT document_path
                FROM car_documents
                WHERE car_id = car_rec.id AND document_type = 'fitness'
                LIMIT 1
            ),
            permit_type = (
                SELECT permit_type
                FROM car_documents
                WHERE car_id = car_rec.id
                LIMIT 1
            )
        WHERE id = car_rec.id;
        
        -- Update from car_statuses
        UPDATE cars
        SET is_available = (SELECT is_available FROM car_statuses WHERE car_id = car_rec.id LIMIT 1),
            current_odometer_reading = (SELECT current_odometer_reading FROM car_statuses WHERE car_id = car_rec.id LIMIT 1),
            last_service_date = (SELECT last_service_date FROM car_statuses WHERE car_id = car_rec.id LIMIT 1),
            next_service_due = (SELECT next_service_due FROM car_statuses WHERE car_id = car_rec.id LIMIT 1),
            damages_or_issues = (SELECT damages_or_issues FROM car_statuses WHERE car_id = car_rec.id LIMIT 1)
        WHERE id = car_rec.id;
        
        -- Update from owners
        UPDATE cars
        SET owner_name = (SELECT name FROM owners WHERE id = car_rec.owner_id LIMIT 1),
            contact_info = (SELECT contact_info FROM owners WHERE id = car_rec.owner_id LIMIT 1)
        WHERE id = car_rec.id;
    END LOOP;
END $$;

-- Add constraints back
ALTER TABLE cars ADD CONSTRAINT valid_rent_duration CHECK (maximum_rent_duration >= minimum_rent_duration);
ALTER TABLE cars ADD CONSTRAINT valid_service_dates CHECK (next_service_due > last_service_date);

-- Drop the normalized tables
DROP TABLE IF EXISTS car_statuses CASCADE;
DROP TABLE IF EXISTS car_documents CASCADE;
DROP TABLE IF EXISTS car_media CASCADE;
DROP TABLE IF EXISTS car_rental_infos CASCADE;
DROP TABLE IF EXISTS car_locations CASCADE;

-- Don't drop owners table if it's referenced by other tables
-- You might want to keep it for data integrity
-- DROP TABLE IF EXISTS owners CASCADE; 