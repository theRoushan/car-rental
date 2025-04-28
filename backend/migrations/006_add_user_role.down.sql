-- Delete admin user
DELETE FROM users WHERE email = 'admin@example.com';

-- Remove role column
ALTER TABLE users DROP COLUMN IF EXISTS role; 