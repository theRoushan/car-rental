-- Create admin user
-- Note: The password hash is for 'admin123', generated using bcrypt
INSERT INTO users (id, name, email, password_hash)
VALUES (
    gen_random_uuid(),
    'Admin User',
    'admin@car-rental.com',
    '$2a$10$XrjX2tDIgCGE5aRqZzGYb.tKlZzJYCFGP9E.rMM6.P.N0Jel0CyE.'
)
ON CONFLICT (email) DO NOTHING; 