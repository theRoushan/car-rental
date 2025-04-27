# Car Rental Database Schema Documentation

This document describes the database schema used in the Car Rental Backend application. It outlines the tables, relationships, and key fields to provide a clear understanding of the data structure.

## Database Tables

The database consists of the following primary tables:

### Users

The `users` table stores information about registered users of the application.

| Column        | Type                     | Description                            | Constraints           |
|---------------|--------------------------|----------------------------------------|-----------------------|
| id            | UUID                     | Unique identifier for the user         | Primary Key           |
| name          | VARCHAR(100)             | Full name of the user                  | NOT NULL              |
| email         | VARCHAR(255)             | Email address of the user              | UNIQUE, NOT NULL      |
| password_hash | VARCHAR(255)             | Hashed password for user authentication| NOT NULL              |
| created_at    | TIMESTAMP WITH TIME ZONE | When the user record was created       | DEFAULT CURRENT_TIMESTAMP |
| updated_at    | TIMESTAMP WITH TIME ZONE | When the user record was last updated  | DEFAULT CURRENT_TIMESTAMP |
| deleted_at    | TIMESTAMP WITH TIME ZONE | Soft delete timestamp                  | NULL allowed          |

Indexes:
- Primary Key: `id`
- Unique Index: `email` (idx_users_email)

### Owners

The `owners` table stores information about car owners who list their vehicles for rental.

| Column        | Type                     | Description                            | Constraints           |
|---------------|--------------------------|----------------------------------------|-----------------------|
| id            | UUID                     | Unique identifier for the owner        | Primary Key           |
| name          | VARCHAR(100)             | Full name of the owner                 | NOT NULL              |
| contact_info  | VARCHAR(255)             | Contact information (phone, email)     | NOT NULL              |
| created_at    | TIMESTAMP WITH TIME ZONE | When the owner record was created      | DEFAULT CURRENT_TIMESTAMP |
| updated_at    | TIMESTAMP WITH TIME ZONE | When the owner record was last updated | DEFAULT CURRENT_TIMESTAMP |
| deleted_at    | TIMESTAMP WITH TIME ZONE | Soft delete timestamp                  | NULL allowed          |

Indexes:
- Primary Key: `id`

### Cars

The `cars` table stores information about the vehicles available for rental.

| Column           | Type                     | Description                             | Constraints           |
|------------------|--------------------------|----------------------------------------|-----------------------|
| id               | UUID                     | Unique identifier for the car          | Primary Key           |
| make             | VARCHAR(100)             | Car manufacturer (e.g., Toyota)        | NOT NULL              |
| model            | VARCHAR(100)             | Car model (e.g., Camry)                | NOT NULL              |
| year             | INTEGER                  | Model year                             | NOT NULL              |
| variant          | VARCHAR(100)             | Model variant (e.g., XLE)              | NOT NULL              |
| fuel_type        | VARCHAR(20)              | Type of fuel used                      | NOT NULL              |
| transmission     | VARCHAR(20)              | Type of transmission                   | NOT NULL              |
| body_type        | VARCHAR(20)              | Body style of the vehicle              | NOT NULL              |
| color            | VARCHAR(50)              | Exterior color                         | NOT NULL              |
| seating_capacity | INTEGER                  | Number of passengers                   | NOT NULL              |
| vehicle_number   | VARCHAR(50)              | Vehicle registration number            | NOT NULL              |
| owner_id         | UUID                     | Reference to the car owner             | Foreign Key           |
| created_at       | TIMESTAMP WITH TIME ZONE | When the car record was created        | DEFAULT CURRENT_TIMESTAMP |
| updated_at       | TIMESTAMP WITH TIME ZONE | When the car record was last updated   | DEFAULT CURRENT_TIMESTAMP |
| deleted_at       | TIMESTAMP WITH TIME ZONE | Soft delete timestamp                  | NULL allowed          |

Constraints:
- Check Constraints:
  - `fuel_type` must be one of: 'Petrol', 'Diesel', 'Electric', 'Hybrid'
  - `transmission` must be one of: 'Manual', 'Automatic', 'CVT'
  - `body_type` must be one of: 'Sedan', 'SUV', 'Hatchback', 'Coupe', 'Van', 'Truck'

Indexes:
- Primary Key: `id`
- Foreign Key: `owner_id` references `owners(id)`
- Unique Index: `vehicle_number` when `deleted_at` is NULL (idx_cars_vehicle_number)
- Index: `owner_id` (idx_cars_owner_id)

### Car Rental Infos

The `car_rental_infos` table stores pricing and rental policy information for each car.

| Column                    | Type                     | Description                               | Constraints           |
|---------------------------|--------------------------|------------------------------------------|-----------------------|
| id                        | UUID                     | Unique identifier                        | Primary Key           |
| car_id                    | UUID                     | Reference to the car                     | Foreign Key           |
| rental_price_per_day      | DECIMAL(10,2)            | Daily rental rate                        | NOT NULL, >= 0        |
| rental_price_per_hour     | DECIMAL(10,2)            | Hourly rental rate                       | NOT NULL, >= 0        |
| minimum_rent_duration     | INTEGER                  | Minimum rental duration (hours)          | NOT NULL, > 0         |
| security_deposit          | DECIMAL(10,2)            | Required security deposit                | NOT NULL, >= 0        |
| late_fee_per_hour         | DECIMAL(10,2)            | Fee for late returns (per hour)          | NOT NULL, >= 0        |
| rental_extend_fee_per_day | DECIMAL(10,2)            | Fee to extend rental (per day)           | NOT NULL, >= 0        |
| rental_extend_fee_per_hour| DECIMAL(10,2)            | Fee to extend rental (per hour)          | NOT NULL, >= 0        |
| created_at                | TIMESTAMP WITH TIME ZONE | When the record was created              | DEFAULT CURRENT_TIMESTAMP |
| updated_at                | TIMESTAMP WITH TIME ZONE | When the record was last updated         | DEFAULT CURRENT_TIMESTAMP |
| deleted_at                | TIMESTAMP WITH TIME ZONE | Soft delete timestamp                    | NULL allowed          |

Indexes:
- Primary Key: `id`
- Foreign Key: `car_id` references `cars(id)` ON DELETE CASCADE
- Index: `car_id` (idx_car_rental_infos_car_id)

### Car Media

The `car_media` table stores links to images and videos for each car.

| Column        | Type                     | Description                               | Constraints           |
|---------------|--------------------------|------------------------------------------|-----------------------|
| id            | UUID                     | Unique identifier                        | Primary Key           |
| car_id        | UUID                     | Reference to the car                     | Foreign Key           |
| type          | VARCHAR(20)              | Media type (e.g., image, video)          | NOT NULL              |
| url           | VARCHAR(255)             | URL to the media resource                | NOT NULL              |
| is_primary    | BOOLEAN                  | Whether this is the primary media        | NOT NULL, DEFAULT false |
| created_at    | TIMESTAMP WITH TIME ZONE | When the record was created              | DEFAULT CURRENT_TIMESTAMP |
| updated_at    | TIMESTAMP WITH TIME ZONE | When the record was last updated         | DEFAULT CURRENT_TIMESTAMP |
| deleted_at    | TIMESTAMP WITH TIME ZONE | Soft delete timestamp                    | NULL allowed          |

Indexes:
- Primary Key: `id`
- Foreign Key: `car_id` references `cars(id)` ON DELETE CASCADE
- Index: `car_id` (idx_car_media_car_id)

### Car Statuses

The `car_statuses` table tracks the availability and condition of each car.

| Column                   | Type                     | Description                                 | Constraints           |
|--------------------------|--------------------------|--------------------------------------------|-----------------------|
| id                       | UUID                     | Unique identifier                          | Primary Key           |
| car_id                   | UUID                     | Reference to the car                       | Foreign Key           |
| is_available             | BOOLEAN                  | Whether the car is available for booking   | NOT NULL, DEFAULT true |
| current_odometer_reading | DECIMAL(10,2)            | Current mileage                            | NOT NULL, >= 0        |
| damages_or_issues        | JSONB                    | Description of any damages or issues       | DEFAULT '[]'          |
| created_at               | TIMESTAMP WITH TIME ZONE | When the record was created                | DEFAULT CURRENT_TIMESTAMP |
| updated_at               | TIMESTAMP WITH TIME ZONE | When the record was last updated           | DEFAULT CURRENT_TIMESTAMP |
| deleted_at               | TIMESTAMP WITH TIME ZONE | Soft delete timestamp                      | NULL allowed          |

Indexes:
- Primary Key: `id`
- Foreign Key: `car_id` references `cars(id)` ON DELETE CASCADE
- Index: `car_id` (idx_car_statuses_car_id)

### Bookings

The `bookings` table records car rental reservations made by users.

| Column        | Type                     | Description                               | Constraints           |
|---------------|--------------------------|------------------------------------------|-----------------------|
| id            | UUID                     | Unique identifier                        | Primary Key           |
| user_id       | UUID                     | Reference to the booking user            | Foreign Key           |
| car_id        | UUID                     | Reference to the booked car              | Foreign Key           |
| start_time    | TIMESTAMP WITH TIME ZONE | Booking start time                       | NOT NULL              |
| end_time      | TIMESTAMP WITH TIME ZONE | Booking end time                         | NOT NULL              |
| status        | VARCHAR(20)              | Booking status                           | NOT NULL              |
| total_price   | DECIMAL(10,2)            | Total price for the booking              | NOT NULL, >= 0        |
| created_at    | TIMESTAMP WITH TIME ZONE | When the booking was created             | DEFAULT CURRENT_TIMESTAMP |
| updated_at    | TIMESTAMP WITH TIME ZONE | When the booking was last updated        | DEFAULT CURRENT_TIMESTAMP |
| deleted_at    | TIMESTAMP WITH TIME ZONE | Soft delete timestamp                    | NULL allowed          |

Constraints:
- Check Constraints:
  - `status` must be one of: 'BOOKED', 'CANCELLED', 'COMPLETED'
  - `end_time` must be after `start_time`

Indexes:
- Primary Key: `id`
- Foreign Key: `user_id` references `users(id)`
- Foreign Key: `car_id` references `cars(id)`
- Index: `user_id` (idx_bookings_user_id)
- Index: `car_id` (idx_bookings_car_id)
- Index: `status` (idx_bookings_status)

## Entity Relationship Diagram

```
┌─────────────┐       ┌─────────────┐      ┌─────────────┐
│    Users    │       │   Bookings  │      │    Cars     │
├─────────────┤       ├─────────────┤      ├─────────────┤
│ id          │       │ id          │      │ id          │
│ name        │       │ user_id     │─────>│ make        │
│ email       │<──────│ car_id      │      │ model       │
│ password_hash│       │ start_time  │      │ year        │
│ created_at  │       │ end_time    │      │ variant     │
│ updated_at  │       │ status      │      │ fuel_type   │
│ deleted_at  │       │ total_price │      │ transmission│
└─────────────┘       │ created_at  │      │ body_type   │
                     │ updated_at  │      │ color       │
                     │ deleted_at  │      │ seating_cap │
                     └─────────────┘      │ vehicle_num │
                                         │ owner_id    │────┐
                                         │ created_at  │    │
                                         │ updated_at  │    │
                                         │ deleted_at  │    │
                                         └─────────────┘    │
                                                            │
                                                            │
                           ┌─────────────┐                 │
                           │   Owners    │                 │
                           ├─────────────┤                 │
                           │ id          │<────────────────┘
                           │ name        │
                           │ contact_info│
                           │ created_at  │
                           │ updated_at  │
                           │ deleted_at  │
                           └─────────────┘
     
     ┌───────────────────┐      ┌─────────────┐      ┌─────────────┐
     │  Car Rental Infos │      │  Car Media  │      │ Car Statuses │
     ├───────────────────┤      ├─────────────┤      ├─────────────┤
     │ id                │      │ id          │      │ id          │
     │ car_id            │─┐    │ car_id      │─┐    │ car_id      │─┐
     │ rental_price_day  │ │    │ type        │ │    │ is_available│ │
     │ rental_price_hour │ │    │ url         │ │    │ odometer    │ │
     │ min_rent_duration │ │    │ is_primary  │ │    │ damages     │ │
     │ security_deposit  │ │    │ created_at  │ │    │ created_at  │ │
     │ late_fee_per_hour │ │    │ updated_at  │ │    │ updated_at  │ │
     │ extend_fee_day    │ │    │ deleted_at  │ │    │ deleted_at  │ │
     │ extend_fee_hour   │ │    └─────────────┘ │    └─────────────┘ │
     │ created_at        │ │                    │                    │
     │ updated_at        │ │                    │                    │
     │ deleted_at        │ │                    │                    │
     └───────────────────┘ │                    │                    │
                           │                    │                    │
                           └────────────────────┴────────────────────┘
                                            │
                                            │
                                    ┌───────┴───────┐
                                    │     Cars      │
                                    └───────────────┘
```

## Relationships

1. **One-to-Many: Users to Bookings**
   - A user can have multiple bookings, but each booking belongs to only one user.

2. **One-to-Many: Cars to Bookings**
   - A car can have multiple bookings (at different times), but each booking is for only one car.

3. **One-to-Many: Owners to Cars**
   - An owner can have multiple cars, but each car belongs to only one owner.

4. **One-to-One: Cars to Car Rental Infos**
   - Each car has one set of rental information.

5. **One-to-Many: Cars to Car Media**
   - A car can have multiple media items (images/videos).

6. **One-to-One: Cars to Car Statuses**
   - Each car has one status record tracking its availability and condition.

## Database Triggers and Functions

The database includes a function called `update_updated_at_column()` that automatically updates the `updated_at` timestamp whenever a record is updated. Triggers apply this function to all tables:

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

Triggers apply this function to all main tables:

```sql
CREATE TRIGGER update_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Similar triggers for other tables
```

## Soft Delete Pattern

All tables implement a soft delete pattern using the `deleted_at` column. Records that are "deleted" are simply marked with a timestamp in this column rather than being physically removed from the database. This allows for data recovery and historical record-keeping.

## Indexes and Performance Considerations

- All foreign keys are indexed to optimize JOIN operations
- The `vehicle_number` column has a unique index with a condition (`WHERE deleted_at IS NULL`), allowing multiple soft-deleted cars with the same number
- The `bookings.status` column is indexed to optimize filtering by booking status
- UUID primary keys are used throughout for security and to facilitate distributed systems 