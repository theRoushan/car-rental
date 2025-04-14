# Car Rental Backend

A production-level car rental application backend built with Go, Fiber, and PostgreSQL.

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

## Getting Started

### Prerequisites

- Go 1.24 or higher
- Docker and Docker Compose
- PostgreSQL 15 (if running locally)

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```
DB_HOST=postgres
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=car_rental
DB_SSL_MODE=disable
JWT_SECRET=your_jwt_secret
PORT=8080
```

### Deployment

#### Using the Deployment Script

The easiest way to deploy the application is using the provided deployment script:

```bash
# Make the script executable
chmod +x deploy.sh

# Run the deployment script
./deploy.sh
```

This script will:
1. Build the migration tool
2. Build the Docker image
3. Start the services
4. Run the database migrations

#### Manual Deployment

If you prefer to deploy manually:

```bash
# Build the Docker image
docker-compose build

# Start the services
docker-compose up -d

# Run migrations (after the database is ready)
docker-compose exec app /app/bin/migrate -up
```

### API Endpoints

#### Cars

- `POST /api/cars` - Create a new car
- `GET /api/cars` - List all cars
- `GET /api/cars/:id` - Get a specific car
- `PUT /api/cars/:id` - Update a car
- `DELETE /api/cars/:id` - Delete a car
- `GET /api/cars/available` - Get available cars

#### Bookings

- `POST /api/bookings` - Create a new booking
- `GET /api/bookings` - List all bookings
- `GET /api/bookings/:id` - Get a specific booking
- `PUT /api/bookings/:id` - Update a booking
- `DELETE /api/bookings/:id` - Delete a booking

#### Authentication

- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login a user
- `GET /api/auth/me` - Get current user information

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

### Running Tests

```bash
go test ./...
```

## License

This project is licensed under the MIT License - see the LICENSE file for details. 