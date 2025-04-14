-- Remove constraints
ALTER TABLE cars
    DROP CONSTRAINT IF EXISTS cars_fuel_type_check;

ALTER TABLE cars
    DROP CONSTRAINT IF EXISTS cars_transmission_check;

ALTER TABLE cars
    DROP CONSTRAINT IF EXISTS cars_body_type_check;

-- Revert column types
ALTER TABLE cars 
    ALTER COLUMN fuel_type TYPE text,
    ALTER COLUMN transmission TYPE text,
    ALTER COLUMN body_type TYPE text; 