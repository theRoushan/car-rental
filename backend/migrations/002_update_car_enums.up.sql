-- Update car table to add proper enum columns
ALTER TABLE cars 
    ALTER COLUMN fuel_type TYPE varchar(20),
    ALTER COLUMN transmission TYPE varchar(20),
    ALTER COLUMN body_type TYPE varchar(20);

-- Add constraints to ensure valid enum values
ALTER TABLE cars
    ADD CONSTRAINT cars_fuel_type_check 
    CHECK (fuel_type IN ('Petrol', 'Diesel', 'Electric', 'Hybrid'));

ALTER TABLE cars
    ADD CONSTRAINT cars_transmission_check 
    CHECK (transmission IN ('Manual', 'Automatic', 'CVT'));

ALTER TABLE cars
    ADD CONSTRAINT cars_body_type_check 
    CHECK (body_type IN ('Sedan', 'SUV', 'Hatchback', 'Coupe', 'Van', 'Truck')); 