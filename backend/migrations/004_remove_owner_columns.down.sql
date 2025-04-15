-- This migration adds back the owner_name and contact_info columns to the cars table
-- in case of a rollback

DO $$
BEGIN
    -- Check if the columns don't exist in the cars table and add them
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'cars' AND column_name = 'owner_name'
    ) THEN
        ALTER TABLE cars ADD COLUMN owner_name VARCHAR(100);
    END IF;

    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'cars' AND column_name = 'contact_info'
    ) THEN
        ALTER TABLE cars ADD COLUMN contact_info VARCHAR(255);
    END IF;
END$$; 