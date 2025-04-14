# Car Rental Backend

This is the backend API for the car rental application. The system uses a normalized database structure optimized for performance and scalability.

## Features

- Comprehensive car management with detailed information
- User authentication and authorization
- Booking management
- Payment processing
- Document management
- Maintenance tracking
- Location and branch management

## Tech Stack

- **Language**: Go 1.24
- **Framework**: Fiber v2
- **Database**: PostgreSQL 15
- **ORM**: GORM
- **Authentication**: JWT
- **Containerization**: Docker & Docker Compose
- **Validation**: go-playground/validator

## Project Structure

```
backend/
├── bin/                # Binary files and tools
├── cmd/                # Application entry points
│   └── api/            # Main API server
├── config/             # Configuration files
├── controllers/        # HTTP request handlers
├── database/           # Database connection and setup
├── middlewares/        # HTTP middlewares
├── migrations/         # Database migrations
├── models/             # Data models
├── routes/             # API routes
├── services/           # Business logic
├── utils/              # Utility functions
├── .env                # Environment variables
├── Dockerfile          # Docker configuration
├── docker-compose.yml  # Docker Compose configuration
├── go.mod              # Go module definition
├── go.sum              # Go module checksums
└── README.md           # Project documentation
```

## Car Model

The car model includes comprehensive information:

### Basic Car Details
- Make, model, year, variant
- Fuel type, transmission, body type
- Color, seating capacity
- Vehicle number, registration state

### Location Info
- Current location
- Available branches

### Rental Info
- Rental price (per day/hour)
- Minimum/maximum rent duration
- Security deposit
- Late fees
- Discounts

### Media
- Images
- Video

### Documentation
- Insurance expiry date
- Pollution certificate validity
- Registration certificate
- Fitness certificate
- Permit type

### Status Info
- Availability
- Odometer reading
- Service dates
- Damages or issues

### Owner Info
- Owner ID, name
- Contact information

## Database Optimization

### Normalized Database Structure

We've implemented a normalized database structure for better performance and scalability:

1. **Core Tables**:
   - `cars`: Contains basic car details (make, model, year, etc.)
   - `owners`: Stores owner information
   - `car_locations`: Tracks where cars are located
   - `car_rental_infos`: Stores rental pricing and terms
   - `car_media`: Manages car images and videos
   - `car_documents`: Organizes documents (insurance, registration, etc.)
   - `car_statuses`: Tracks car availability and maintenance status
   - `bookings`: Manages car reservations

2. **Benefits**:
   - **Reduced Update Costs**: Updates to frequently changing data only affect smaller tables
   - **Improved Query Performance**: Can query just what's needed without loading all car data
   - **Better Data Integrity**: Proper relationships help enforce referential integrity
   - **Support for History**: Can maintain history of changes (especially for status)
   - **Scalability**: Better handles a growing system with thousands of cars and operations

3. **Relationships**:
   - Cars have one-to-many relationships with media, documents, and bookings
   - Cars have one-to-one relationships with location, rental info, and status
   - Owners have one-to-many relationships with cars

### Data Access Layer

1. **Service Pattern**:
   - Implemented `CarService` to abstract database operations
   - All car-related operations use transactions for data consistency
   - Efficient query patterns for loading related data

2. **API Compatibility**:
   - Maintained backward compatibility with API responses
   - Added `ToCarResponse()` method to present normalized data in a flattened format

### Migration

1. **Migration Scripts**:
   - Created `002_normalize_car_tables.up.sql` to create normalized tables
   - Data migration logic to transfer existing data to new structure
   - Rollback migration in `002_normalize_car_tables.down.sql`

## Getting Started

### Prerequisites

- Go 1.18 or later
- PostgreSQL 13 or later

### Installation

1. Clone the repository
2. Set up your `.env` file with database credentials
3. Run migrations:
```
go run bin/migrate.go -up
```
4. Start the server:
```
go run cmd/api/main.go
```

## API Documentation

The API follows RESTful principles:

- `GET /api/cars`: Get all cars
- `GET /api/cars/:id`: Get a specific car
- `POST /api/cars`: Create a new car
- `PUT /api/cars/:id`: Update a car
- `DELETE /api/cars/:id`: Delete a car
- `GET /api/cars/available`: Get available cars for a time period

## Development

### Running Locally

```bash
# Start the database
docker-compose up -d postgres

# Run migrations
go run bin/migrate.go -up

# Start the server
go run cmd/api/main.go
```