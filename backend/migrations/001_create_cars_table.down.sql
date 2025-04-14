-- Drop trigger
DROP TRIGGER IF EXISTS update_cars_updated_at ON cars;

-- Drop function
DROP FUNCTION IF EXISTS update_updated_at_column();

-- Drop indexes
DROP INDEX IF EXISTS idx_cars_vehicle_number;
DROP INDEX IF EXISTS idx_cars_is_available;
DROP INDEX IF EXISTS idx_cars_location;
DROP INDEX IF EXISTS idx_cars_owner;

-- Drop tables
DROP TABLE IF EXISTS cars;
DROP TABLE IF EXISTS base;

-- Drop enum types
DROP TYPE IF EXISTS fuel_type;
DROP TYPE IF EXISTS transmission_type;
DROP TYPE IF EXISTS body_type;
DROP TYPE IF EXISTS permit_type; 