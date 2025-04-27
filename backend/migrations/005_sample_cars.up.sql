-- Add 35 sample cars with realistic data

-- Create additional car owners
DO $$
DECLARE
    owner1_id UUID := '7f333df6-90a4-4fda-8dd3-9485d27cee40';
    owner2_id UUID := '8f333df6-90a4-4fda-8dd3-9485d27cee41';
    owner3_id UUID := '9f333df6-90a4-4fda-8dd3-9485d27cee42';
    owner4_id UUID := 'af333df6-90a4-4fda-8dd3-9485d27cee43';
    owner5_id UUID := 'bf333df6-90a4-4fda-8dd3-9485d27cee44';
BEGIN
    -- Insert owners with fixed IDs
    INSERT INTO owners (id, name, contact_info)
    VALUES 
        (owner1_id, 'Robert Johnson', 'robert@example.com'),
        (owner2_id, 'Maria Garcia', 'maria@example.com'),
        (owner3_id, 'David Lee', 'david@example.com'),
        (owner4_id, 'Sarah Wilson', 'sarah@example.com'),
        (owner5_id, 'Michael Brown', 'michael@example.com')
    ON CONFLICT (id) DO NOTHING;
    
    -- Insert sample cars
    DECLARE
        car_id UUID;
        rental_id UUID;
        media_id UUID;
        status_id UUID;
    BEGIN
        -- Toyota cars
        car_id := 'a1333df6-90a4-4fda-8dd3-9485d27cee43';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Toyota', 'Camry', 2022, 'SE', 'Petrol', 'Automatic', 'Sedan', 'Silver', 5, 'TYC2022', owner1_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 55.00, 9.00, 4, 550.00, 12.00, 65.00, 11.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/camry1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/camry2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 8500.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Toyota RAV4
        car_id := 'a1333df6-90a4-4fda-8dd3-9485d27cee44';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Toyota', 'RAV4', 2023, 'XLE', 'Hybrid', 'CVT', 'SUV', 'Blue', 5, 'TYR2023', owner1_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 60.00, 10.00, 4, 600.00, 13.00, 70.00, 12.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/rav41.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/rav42.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 2500.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Honda car
        car_id := 'a2333df6-90a4-4fda-8dd3-9485d27cee45';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Honda', 'Civic', 2023, 'EX', 'Petrol', 'CVT', 'Sedan', 'Red', 5, 'HCV2023', owner1_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 52.00, 8.50, 4, 500.00, 11.00, 62.00, 10.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/civic1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/civic2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 3500.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Honda Accord
        car_id := 'a2333df6-90a4-4fda-8dd3-9485d27cee46';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Honda', 'Accord', 2022, 'Sport', 'Petrol', 'Automatic', 'Sedan', 'Black', 5, 'HAC2022', owner1_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 58.00, 9.50, 4, 550.00, 12.00, 68.00, 11.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/accord1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/accord2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 6500.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Nissan car
        car_id := 'a3333df6-90a4-4fda-8dd3-9485d27cee47';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Nissan', 'Altima', 2021, 'SV', 'Petrol', 'Automatic', 'Sedan', 'Black', 5, 'NAL2021', owner2_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 48.00, 8.00, 4, 480.00, 10.00, 58.00, 9.50)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/altima1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/altima2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 12000.00, '["Minor dent on passenger door"]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Nissan Rogue
        car_id := 'a3333df6-90a4-4fda-8dd3-9485d27cee48';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Nissan', 'Rogue', 2022, 'SL', 'Petrol', 'CVT', 'SUV', 'Silver', 5, 'NRG2022', owner2_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 56.00, 9.00, 4, 550.00, 12.00, 66.00, 11.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/rogue1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/rogue2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 7800.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Tesla car
        car_id := 'a4333df6-90a4-4fda-8dd3-9485d27cee49';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Tesla', 'Model 3', 2023, 'Long Range', 'Electric', 'Automatic', 'Sedan', 'White', 5, 'TM32023', owner2_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 85.00, 15.00, 4, 1000.00, 20.00, 95.00, 18.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/tesla1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/tesla2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 5000.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Tesla Model Y
        car_id := 'a4333df6-90a4-4fda-8dd3-9485d27cee50';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Tesla', 'Model Y', 2023, 'Performance', 'Electric', 'Automatic', 'SUV', 'Black', 5, 'TMY2023', owner2_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 95.00, 18.00, 4, 1200.00, 22.00, 105.00, 20.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/model_y1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/model_y2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 3200.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- BMW car
        car_id := 'a5333df6-90a4-4fda-8dd3-9485d27cee51';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'BMW', '3 Series', 2022, '330i', 'Petrol', 'Automatic', 'Sedan', 'Blue', 5, 'BMW2022', owner3_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 75.00, 13.00, 4, 900.00, 18.00, 85.00, 16.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/bmw1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/bmw2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 7800.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- BMW X5
        car_id := 'a5333df6-90a4-4fda-8dd3-9485d27cee52';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'BMW', 'X5', 2022, 'xDrive40i', 'Petrol', 'Automatic', 'SUV', 'Black', 5, 'BMW5X2022', owner3_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 98.00, 17.00, 4, 1200.00, 22.00, 108.00, 19.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/bmwx51.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/bmwx52.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 5200.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Audi car
        car_id := 'a6333df6-90a4-4fda-8dd3-9485d27cee53';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Audi', 'A4', 2022, 'Premium Plus', 'Petrol', 'Automatic', 'Sedan', 'Gray', 5, 'AAA2022', owner3_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 78.00, 14.00, 4, 950.00, 19.00, 88.00, 17.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/audi1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/audi2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 6500.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Audi Q5
        car_id := 'a6333df6-90a4-4fda-8dd3-9485d27cee54';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Audi', 'Q5', 2023, 'Prestige', 'Petrol', 'Automatic', 'SUV', 'White', 5, 'AQ52023', owner3_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 88.00, 15.00, 4, 1050.00, 20.00, 98.00, 18.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/audiq51.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/audiq52.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 2800.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Mercedes car
        car_id := 'a7333df6-90a4-4fda-8dd3-9485d27cee55';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Mercedes', 'C-Class', 2021, 'C300', 'Petrol', 'Automatic', 'Sedan', 'Black', 5, 'MBC2021', owner4_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 80.00, 15.00, 4, 1000.00, 20.00, 90.00, 18.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/mercedes1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/mercedes2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 9500.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Mercedes GLC
        car_id := 'a7333df6-90a4-4fda-8dd3-9485d27cee56';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Mercedes', 'GLC', 2022, 'GLC300', 'Petrol', 'Automatic', 'SUV', 'Silver', 5, 'MBGLC2022', owner4_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 92.00, 16.00, 4, 1100.00, 21.00, 102.00, 19.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/glc1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/glc2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 6200.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Hyundai car
        car_id := 'a8333df6-90a4-4fda-8dd3-9485d27cee57';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Hyundai', 'Elantra', 2022, 'SEL', 'Petrol', 'Automatic', 'Sedan', 'Silver', 5, 'HYE2022', owner4_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 45.00, 7.50, 4, 450.00, 9.00, 55.00, 8.50)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/elantra1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/elantra2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 4200.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Hyundai Tucson
        car_id := 'a8333df6-90a4-4fda-8dd3-9485d27cee58';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Hyundai', 'Tucson', 2022, 'Limited', 'Petrol', 'Automatic', 'SUV', 'Green', 5, 'HTC2022', owner4_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 52.00, 8.50, 4, 520.00, 11.00, 62.00, 10.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/tucson1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/tucson2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 5600.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Kia car
        car_id := 'a9333df6-90a4-4fda-8dd3-9485d27cee59';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Kia', 'Sportage', 2022, 'EX', 'Petrol', 'Automatic', 'SUV', 'White', 5, 'KSP2022', owner4_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 55.00, 9.00, 4, 550.00, 12.00, 65.00, 11.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/sportage1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/sportage2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 7800.00, '["Small scratch on rear bumper"]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Kia K5
        car_id := 'a9333df6-90a4-4fda-8dd3-9485d27cee60';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Kia', 'K5', 2023, 'GT-Line', 'Petrol', 'Automatic', 'Sedan', 'Blue', 5, 'KK52023', owner4_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 54.00, 9.00, 4, 540.00, 11.00, 64.00, 10.50)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/k51.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/k52.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 2400.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Ford car
        car_id := 'aa333df6-90a4-4fda-8dd3-9485d27cee61';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Ford', 'Mustang', 2022, 'GT', 'Petrol', 'Manual', 'Coupe', 'Red', 4, 'FMU2022', owner5_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 85.00, 15.00, 4, 1000.00, 20.00, 95.00, 18.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/mustang1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/mustang2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 5500.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Ford Explorer
        car_id := 'aa333df6-90a4-4fda-8dd3-9485d27cee62';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Ford', 'Explorer', 2022, 'Limited', 'Petrol', 'Automatic', 'SUV', 'White', 7, 'FEX2022', owner5_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 78.00, 13.00, 4, 950.00, 19.00, 88.00, 16.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/explorer1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/explorer2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 9200.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Chevrolet car
        car_id := 'ab333df6-90a4-4fda-8dd3-9485d27cee63';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Chevrolet', 'Suburban', 2021, 'LT', 'Petrol', 'Automatic', 'SUV', 'Black', 8, 'CSS2021', owner5_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 90.00, 16.00, 6, 1200.00, 22.00, 100.00, 20.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/suburban1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/suburban2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 8800.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Chevrolet Malibu
        car_id := 'ab333df6-90a4-4fda-8dd3-9485d27cee64';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Chevrolet', 'Malibu', 2022, 'LT', 'Petrol', 'Automatic', 'Sedan', 'Silver', 5, 'CML2022', owner5_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 50.00, 8.00, 4, 500.00, 10.00, 60.00, 9.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/malibu1.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/malibu2.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 6700.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Mazda car
        car_id := 'ac333df6-90a4-4fda-8dd3-9485d27cee65';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Mazda', 'CX-5', 2022, 'Grand Touring', 'Petrol', 'Automatic', 'SUV', 'Red', 5, 'MCX52022', owner5_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 62.00, 10.00, 4, 620.00, 13.00, 72.00, 12.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/cx51.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/cx52.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 5100.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
        
        -- Mazda car
        car_id := 'ac333df6-90a4-4fda-8dd3-9485d27cee66';
        INSERT INTO cars (id, make, model, year, variant, fuel_type, transmission, body_type, color, seating_capacity, vehicle_number, owner_id)
        VALUES (car_id, 'Mazda', '3', 2022, 'Premium', 'Petrol', 'Automatic', 'Sedan', 'Blue', 5, 'MZ32022', owner5_id)
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO car_rental_infos (id, car_id, rental_price_per_day, rental_price_per_hour, minimum_rent_duration, security_deposit, late_fee_per_hour, rental_extend_fee_per_day, rental_extend_fee_per_hour)
        VALUES (gen_random_uuid(), car_id, 48.00, 8.00, 4, 480.00, 10.00, 58.00, 9.00)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_media (id, car_id, type, url, is_primary)
        VALUES 
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/mazda31.jpg', true),
            (gen_random_uuid(), car_id, 'image', 'https://example.com/cars/mazda32.jpg', false)
        ON CONFLICT DO NOTHING;
        
        INSERT INTO car_statuses (id, car_id, is_available, current_odometer_reading, damages_or_issues)
        VALUES (gen_random_uuid(), car_id, true, 3800.00, '[]'::jsonb)
        ON CONFLICT DO NOTHING;
    END;
END $$; 