-- Clean up sample data

-- Define the fixed UUIDs used in the up migration
DO $$
DECLARE
    owner1_id UUID := '3f333df6-90a4-4fda-8dd3-9485d27cee36';
    owner2_id UUID := '4f333df6-90a4-4fda-8dd3-9485d27cee37';
    car1_id UUID := '5f333df6-90a4-4fda-8dd3-9485d27cee38';
    car2_id UUID := '6f333df6-90a4-4fda-8dd3-9485d27cee39';
BEGIN
    -- Delete car statuses
    DELETE FROM car_statuses WHERE car_id IN (car1_id, car2_id);

    -- Delete car media
    DELETE FROM car_media WHERE car_id IN (car1_id, car2_id);

    -- Delete car rental info
    DELETE FROM car_rental_infos WHERE car_id IN (car1_id, car2_id);

    -- Delete sample cars
    DELETE FROM cars WHERE id IN (car1_id, car2_id);

    -- Delete sample owners
    DELETE FROM owners WHERE id IN (owner1_id, owner2_id);
END $$; 