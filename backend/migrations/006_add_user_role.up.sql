-- Add role column to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS role VARCHAR(20) NOT NULL DEFAULT 'user';

-- Create admin user (password: admin123)
INSERT INTO users (id, name, email, password_hash, role, created_at, updated_at)
VALUES (
  'a1b2c3d4-e5f6-47a8-9b0c-1d2e3f4a5b6c',
  'Admin User',
  'admin@example.com',
  '$2a$10$UEVCo6QsNFgD1ck2VrBtWeUzL0oAEtHw6RnF/hqmARGpHVt/Jjpd.',
  'admin',
  NOW(),
  NOW()
) ON CONFLICT (email) DO NOTHING; 