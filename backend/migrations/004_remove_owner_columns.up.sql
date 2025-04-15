-- This migration removes the owner_name and contact_info columns from the cars table
-- since they should be in the owners table in the normalized schema

DO $$
BEGIN
    -- Check if the columns exist in the cars table and drop them
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'cars' AND column_name = 'owner_name'
    ) THEN
        ALTER TABLE cars DROP COLUMN owner_name;
    END IF;

    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'cars' AND column_name = 'contact_info'
    ) THEN
        ALTER TABLE cars DROP COLUMN contact_info;
    END IF;
END$$; 