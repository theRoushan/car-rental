-- Drop triggers
DROP TRIGGER IF EXISTS update_bookings_updated_at ON bookings;
DROP TRIGGER IF EXISTS update_car_statuses_updated_at ON car_statuses;
DROP TRIGGER IF EXISTS update_car_media_updated_at ON car_media;
DROP TRIGGER IF EXISTS update_car_rental_infos_updated_at ON car_rental_infos;
DROP TRIGGER IF EXISTS update_cars_updated_at ON cars;
DROP TRIGGER IF EXISTS update_owners_updated_at ON owners;
DROP TRIGGER IF EXISTS update_users_updated_at ON users;

-- Drop function
DROP FUNCTION IF EXISTS update_updated_at_column();

-- Drop tables in reverse order (respecting foreign key dependencies)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS car_statuses;
DROP TABLE IF EXISTS car_media;
DROP TABLE IF EXISTS car_rental_infos;
DROP TABLE IF EXISTS cars;
DROP TABLE IF EXISTS owners;
DROP TABLE IF EXISTS users;

-- Drop enums
DROP TYPE IF EXISTS booking_status;
DROP TYPE IF EXISTS body_type;
DROP TYPE IF EXISTS transmission_type;
DROP TYPE IF EXISTS fuel_type; 