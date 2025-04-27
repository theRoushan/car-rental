-- Remove sample cars added in 005_sample_cars.up.sql

-- Delete car statuses
DELETE FROM car_statuses WHERE car_id IN (
    'a1333df6-90a4-4fda-8dd3-9485d27cee43',
    'a1333df6-90a4-4fda-8dd3-9485d27cee44',
    'a2333df6-90a4-4fda-8dd3-9485d27cee45',
    'a2333df6-90a4-4fda-8dd3-9485d27cee46',
    'a3333df6-90a4-4fda-8dd3-9485d27cee47',
    'a3333df6-90a4-4fda-8dd3-9485d27cee48',
    'a4333df6-90a4-4fda-8dd3-9485d27cee49',
    'a4333df6-90a4-4fda-8dd3-9485d27cee50',
    'a5333df6-90a4-4fda-8dd3-9485d27cee51',
    'a5333df6-90a4-4fda-8dd3-9485d27cee52',
    'a6333df6-90a4-4fda-8dd3-9485d27cee53',
    'a6333df6-90a4-4fda-8dd3-9485d27cee54',
    'a7333df6-90a4-4fda-8dd3-9485d27cee55',
    'a7333df6-90a4-4fda-8dd3-9485d27cee56',
    'a8333df6-90a4-4fda-8dd3-9485d27cee57',
    'a8333df6-90a4-4fda-8dd3-9485d27cee58',
    'a9333df6-90a4-4fda-8dd3-9485d27cee59',
    'a9333df6-90a4-4fda-8dd3-9485d27cee60',
    'aa333df6-90a4-4fda-8dd3-9485d27cee61',
    'aa333df6-90a4-4fda-8dd3-9485d27cee62',
    'ab333df6-90a4-4fda-8dd3-9485d27cee63',
    'ab333df6-90a4-4fda-8dd3-9485d27cee64',
    'ac333df6-90a4-4fda-8dd3-9485d27cee65',
    'ac333df6-90a4-4fda-8dd3-9485d27cee66'
);

-- Delete car media
DELETE FROM car_media WHERE car_id IN (
    'a1333df6-90a4-4fda-8dd3-9485d27cee43',
    'a1333df6-90a4-4fda-8dd3-9485d27cee44',
    'a2333df6-90a4-4fda-8dd3-9485d27cee45',
    'a2333df6-90a4-4fda-8dd3-9485d27cee46',
    'a3333df6-90a4-4fda-8dd3-9485d27cee47',
    'a3333df6-90a4-4fda-8dd3-9485d27cee48',
    'a4333df6-90a4-4fda-8dd3-9485d27cee49',
    'a4333df6-90a4-4fda-8dd3-9485d27cee50',
    'a5333df6-90a4-4fda-8dd3-9485d27cee51',
    'a5333df6-90a4-4fda-8dd3-9485d27cee52',
    'a6333df6-90a4-4fda-8dd3-9485d27cee53',
    'a6333df6-90a4-4fda-8dd3-9485d27cee54',
    'a7333df6-90a4-4fda-8dd3-9485d27cee55',
    'a7333df6-90a4-4fda-8dd3-9485d27cee56',
    'a8333df6-90a4-4fda-8dd3-9485d27cee57',
    'a8333df6-90a4-4fda-8dd3-9485d27cee58',
    'a9333df6-90a4-4fda-8dd3-9485d27cee59',
    'a9333df6-90a4-4fda-8dd3-9485d27cee60',
    'aa333df6-90a4-4fda-8dd3-9485d27cee61',
    'aa333df6-90a4-4fda-8dd3-9485d27cee62',
    'ab333df6-90a4-4fda-8dd3-9485d27cee63',
    'ab333df6-90a4-4fda-8dd3-9485d27cee64',
    'ac333df6-90a4-4fda-8dd3-9485d27cee65',
    'ac333df6-90a4-4fda-8dd3-9485d27cee66'
);

-- Delete car rental info
DELETE FROM car_rental_infos WHERE car_id IN (
    'a1333df6-90a4-4fda-8dd3-9485d27cee43',
    'a1333df6-90a4-4fda-8dd3-9485d27cee44',
    'a2333df6-90a4-4fda-8dd3-9485d27cee45',
    'a2333df6-90a4-4fda-8dd3-9485d27cee46',
    'a3333df6-90a4-4fda-8dd3-9485d27cee47',
    'a3333df6-90a4-4fda-8dd3-9485d27cee48',
    'a4333df6-90a4-4fda-8dd3-9485d27cee49',
    'a4333df6-90a4-4fda-8dd3-9485d27cee50',
    'a5333df6-90a4-4fda-8dd3-9485d27cee51',
    'a5333df6-90a4-4fda-8dd3-9485d27cee52',
    'a6333df6-90a4-4fda-8dd3-9485d27cee53',
    'a6333df6-90a4-4fda-8dd3-9485d27cee54',
    'a7333df6-90a4-4fda-8dd3-9485d27cee55',
    'a7333df6-90a4-4fda-8dd3-9485d27cee56',
    'a8333df6-90a4-4fda-8dd3-9485d27cee57',
    'a8333df6-90a4-4fda-8dd3-9485d27cee58',
    'a9333df6-90a4-4fda-8dd3-9485d27cee59',
    'a9333df6-90a4-4fda-8dd3-9485d27cee60',
    'aa333df6-90a4-4fda-8dd3-9485d27cee61',
    'aa333df6-90a4-4fda-8dd3-9485d27cee62',
    'ab333df6-90a4-4fda-8dd3-9485d27cee63',
    'ab333df6-90a4-4fda-8dd3-9485d27cee64',
    'ac333df6-90a4-4fda-8dd3-9485d27cee65',
    'ac333df6-90a4-4fda-8dd3-9485d27cee66'
);

-- Delete cars
DELETE FROM cars WHERE id IN (
    'a1333df6-90a4-4fda-8dd3-9485d27cee43',
    'a1333df6-90a4-4fda-8dd3-9485d27cee44',
    'a2333df6-90a4-4fda-8dd3-9485d27cee45',
    'a2333df6-90a4-4fda-8dd3-9485d27cee46',
    'a3333df6-90a4-4fda-8dd3-9485d27cee47',
    'a3333df6-90a4-4fda-8dd3-9485d27cee48',
    'a4333df6-90a4-4fda-8dd3-9485d27cee49',
    'a4333df6-90a4-4fda-8dd3-9485d27cee50',
    'a5333df6-90a4-4fda-8dd3-9485d27cee51',
    'a5333df6-90a4-4fda-8dd3-9485d27cee52',
    'a6333df6-90a4-4fda-8dd3-9485d27cee53',
    'a6333df6-90a4-4fda-8dd3-9485d27cee54',
    'a7333df6-90a4-4fda-8dd3-9485d27cee55',
    'a7333df6-90a4-4fda-8dd3-9485d27cee56',
    'a8333df6-90a4-4fda-8dd3-9485d27cee57',
    'a8333df6-90a4-4fda-8dd3-9485d27cee58',
    'a9333df6-90a4-4fda-8dd3-9485d27cee59',
    'a9333df6-90a4-4fda-8dd3-9485d27cee60',
    'aa333df6-90a4-4fda-8dd3-9485d27cee61',
    'aa333df6-90a4-4fda-8dd3-9485d27cee62',
    'ab333df6-90a4-4fda-8dd3-9485d27cee63',
    'ab333df6-90a4-4fda-8dd3-9485d27cee64',
    'ac333df6-90a4-4fda-8dd3-9485d27cee65',
    'ac333df6-90a4-4fda-8dd3-9485d27cee66'
);

-- Delete owners
DELETE FROM owners WHERE id IN (
    '7f333df6-90a4-4fda-8dd3-9485d27cee40',
    '8f333df6-90a4-4fda-8dd3-9485d27cee41',
    '9f333df6-90a4-4fda-8dd3-9485d27cee42',
    'af333df6-90a4-4fda-8dd3-9485d27cee43',
    'bf333df6-90a4-4fda-8dd3-9485d27cee44'
); 