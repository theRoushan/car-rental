-- Migration: fix_user_constraint
-- Created at: Sat Apr 26 22:22:00 IST 2025
-- Description: Fix user email constraint issue

-- Drop the constraint if it exists and create proper index
DO $$
BEGIN
    -- Drop the constraint if it exists (won't throw error if it doesn't)
    BEGIN
        ALTER TABLE users DROP CONSTRAINT IF EXISTS uni_users_email;
    EXCEPTION WHEN OTHERS THEN
        -- Do nothing, just continue
    END;

    -- Ensure we have the correct index
    IF EXISTS (
        SELECT 1 
        FROM pg_indexes 
        WHERE indexname = 'idx_users_email'
    ) THEN
        -- If it exists, drop it first to recreate with the correct condition
        DROP INDEX idx_users_email;
    END IF;

    -- Create the proper unique index
    CREATE UNIQUE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;
END$$; 