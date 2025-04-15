-- This migration fixes the constraint issue by safely dropping it if it exists
DO $$
BEGIN
    -- Check if the constraint exists in the information schema
    IF EXISTS (
        SELECT 1 
        FROM pg_constraint 
        WHERE conname = 'uni_cars_vehicle_number'
    ) THEN
        -- If it exists, drop it
        ALTER TABLE cars DROP CONSTRAINT uni_cars_vehicle_number;
    END IF;
    
    -- Ensure vehicle_number has a unique index with the correct name
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_indexes 
        WHERE indexname = 'idx_cars_vehicle_number'
    ) THEN
        CREATE UNIQUE INDEX idx_cars_vehicle_number ON cars(vehicle_number);
    END IF;
END$$; 