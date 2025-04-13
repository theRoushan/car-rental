# Car Rental System Backend

A production-grade Go backend for a car rental system, built with Fiber, GORM, and PostgreSQL.

## Features

- User authentication with JWT
- Car management (CRUD operations)
- Car availability checking
- Booking management with conflict prevention
- Hourly-based pricing
- Docker support for easy deployment

## Tech Stack

- Go 1.21
- Fiber (HTTP framework)
- GORM (ORM)
- PostgreSQL
- JWT for authentication
- Docker & Docker Compose

## Prerequisites

- Go 1.21 or later
- Docker and Docker Compose
- PostgreSQL (if running locally)

## Project Structure

```
.
├── cmd/
│   └── api/
│       └── main.go
├── config/
│   └── config.go
├── controllers/
│   ├── auth.go
│   ├── booking.go
│   └── car.go
├── database/
│   └── database.go
├── middlewares/
│   └── auth.go
├── models/
│   ├── base.go
│   ├── booking.go
│   ├── car.go
│   └── user.go
├── routes/
│   └── routes.go
├── .env
├── Dockerfile
├── docker-compose.yml
└── README.md
```

## Getting Started

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd car-rental-backend
   ```

2. Create a `.env` file:
   ```env
   PORT=8080
   ENV=development
   DB_HOST=localhost
   DB_PORT=5432
   DB_USER=postgres
   DB_PASSWORD=postgres
   DB_NAME=car_rental
   DB_SSL_MODE=disable
   JWT_SECRET=your-secret-key-here
   JWT_EXPIRATION_HOURS=24
   ```

3. Run with Docker Compose:
   ```bash
   docker-compose up --build
   ```

   Or run locally:
   ```bash
   go mod download
   go run cmd/api/main.go
   ```

## API Endpoints

### Authentication
- `POST /auth/register` - Register a new user
- `POST /auth/login` - Login user

### Cars
- `GET /api/cars` - List all cars
- `GET /api/cars/available` - Get available cars in time range
- `GET /api/cars/:id` - Get car details
- `POST /api/cars` - Add new car
- `PUT /api/cars/:id` - Update car
- `DELETE /api/cars/:id` - Delete car

### Bookings
- `POST /api/bookings` - Create booking
- `GET /api/bookings/:id` - Get booking details
- `DELETE /api/bookings/:id` - Cancel booking
- `GET /api/users/:userId/bookings` - Get user's bookings

## Request Examples

### Register User
```json
POST /auth/register
{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
}
```

### Create Booking
```json
POST /api/bookings
{
    "car_id": "uuid-here",
    "start_time": "2024-03-20T10:00:00Z",
    "end_time": "2024-03-20T12:00:00Z"
}
```

## Development

1. Install dependencies:
   ```bash
   go mod download
   ```

2. Run tests:
   ```bash
   go test ./...
   ```

3. Format code:
   ```bash
   go fmt ./...
   ```

## License

MIT 