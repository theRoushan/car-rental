-- Add sample data

-- Add some owners with fixed UUIDs to avoid conflicts
DO $$
DECLARE
    owner1_id UUID := '3f333df6-90a4-4fda-8dd3-9485d27cee36';
    owner2_id UUID := '4f333df6-90a4-4fda-8dd3-9485d27cee37';
BEGIN
    -- Insert owners with fixed IDs
    INSERT INTO owners (id, name, contact_info)
    VALUES 
        (owner1_id, 'John Smith', 'john@example.com'),
        (owner2_id, 'Jane Doe', 'jane@example.com')
    ON CONFLICT (id) DO NOTHING;
    
    -- Variables for car IDs
    DECLARE
        car1_id UUID := '5f333df6-90a4-4fda-8dd3-9485d27cee38';
        car2_id UUID := '6f333df6-90a4-4fda-8dd3-9485d27cee39';
    BEGIN
        -- Insert sample cars with fixed IDs
        INSERT INTO cars (
            id, make, model, year, variant, fuel_type, transmission, body_type, 
            color, seating_capacity, vehicle_number, owner_id
        ) 
        VALUES 
            (
                car1_id, 'Toyota', 'Corolla', 2021, 'LE', 'Petrol', 
                'Automatic', 'Sedan', 'White', 5, 'ABC123', owner1_id
            ),
            (
                car2_id, 'Honda', 'CR-V', 2022, 'EX', 'Hybrid', 
                'CVT', 'SUV', 'Blue', 5, 'XYZ789', owner2_id
            )
        ON CONFLICT (id) DO NOTHING;
        
        -- Add rental info for the first car
        INSERT INTO car_rental_infos (
            id, car_id, rental_price_per_day, rental_price_per_hour, 
            minimum_rent_duration, security_deposit, late_fee_per_hour,
            rental_extend_fee_per_day, rental_extend_fee_per_hour
        )
        VALUES (
            gen_random_uuid(), car1_id, 50.00, 8.00, 4, 500.00, 10.00, 60.00, 10.00
        )
        ON CONFLICT DO NOTHING;
        
        -- Add rental info for the second car
        INSERT INTO car_rental_infos (
            id, car_id, rental_price_per_day, rental_price_per_hour, 
            minimum_rent_duration, security_deposit, late_fee_per_hour,
            rental_extend_fee_per_day, rental_extend_fee_per_hour
        )
        VALUES (
            gen_random_uuid(), car2_id, 65.00, 12.00, 4, 750.00, 15.00, 75.00, 15.00
        )
        ON CONFLICT DO NOTHING;
        
        -- Add media for cars
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car1_id, 'image', 'https://example.com/cars/corolla1.jpg', true),
            (gen_random_uuid(), car1_id, 'image', 'https://example.com/cars/corolla2.jpg', false),
            (gen_random_uuid(), car2_id, 'image', 'https://example.com/cars/crv1.jpg', true),
            (gen_random_uuid(), car2_id, 'image', 'https://example.com/cars/crv2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        -- Add car status
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES 
            (gen_random_uuid(), car1_id, true, 5000.00, '[]'::jsonb),
            (gen_random_uuid(), car2_id, true, 2500.00, '["Small scratch on rear bumper"]'::jsonb)
        ON CONFLICT DO NOTHING;
    END;
END $$; 