# Car Rental Backend API Documentation

This document outlines the API endpoints available in the Car Rental Backend service. The API is designed to facilitate car rental operations, including user authentication, car management, bookings, and owner management.

## Base URL

All API endpoints are relative to the base URL:

```
http://localhost:8080
```

## Authentication

The API uses JWT (JSON Web Token) for authentication. Protected endpoints require a valid JWT token to be included in the Authorization header.

```
Authorization: Bearer <token>
```

### Register a New User

Register a new user account.

- **URL**: `/auth/register`
- **Method**: `POST`
- **Auth Required**: No
- **Content-Type**: `application/json`

**Request Body:**

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**

```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      "name": "John Doe",
      "email": "john@example.com",
      "created_at": "2023-04-19T12:00:00Z"
    }
  }
}
```

### Login

Authenticate a user and retrieve a JWT token.

- **URL**: `/auth/login`
- **Method**: `POST`
- **Auth Required**: No
- **Content-Type**: `application/json`

**Request Body:**

```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      "name": "John Doe",
      "email": "john@example.com",
      "created_at": "2023-04-19T12:00:00Z"
    }
  }
}
```

## Car Management

### Create a Car

Add a new car to the system.

- **URL**: `/api/cars`
- **Method**: `POST`
- **Auth Required**: Yes
- **Content-Type**: `application/json`

**Request Body:**

```json
{
  "make": "Toyota",
  "model": "Camry",
  "year": 2023,
  "variant": "XLE",
  "fuel_type": "Petrol",
  "transmission": "Automatic",
  "body_type": "Sedan",
  "color": "Silver",
  "seating_capacity": 5,
  "vehicle_number": "ABC123",
  "owner": {
    "owner_id": "f47ac10b-58cc-4372-a567-0e02b2c3d479"
  },
  "rental_info": {
    "rental_price_per_day": 50.00,
    "rental_price_per_hour": 10.00,
    "minimum_rent_duration": 4,
    "security_deposit": 200.00,
    "late_fee_per_hour": 15.00
  },
  "status": {
    "is_available": true,
    "current_odometer_reading": 15000
  },
  "media": {
    "images": ["https://example.com/car1.jpg", "https://example.com/car2.jpg"]
  }
}
```

**Response:**

```json
{
  "success": true,
  "message": "Car created successfully",
  "data": {
    "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "make": "Toyota",
    "model": "Camry",
    "year": 2023,
    "variant": "XLE",
    "fuel_type": "Petrol",
    "transmission": "Automatic",
    "body_type": "Sedan",
    "color": "Silver",
    "seating_capacity": 5,
    "vehicle_number": "ABC123",
    "owner": {
      "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      "name": "John Smith",
      "contact_info": "+1234567890"
    },
    "rental_info": {
      "rental_price_per_day": 50.00,
      "rental_price_per_hour": 10.00,
      "minimum_rent_duration": 4,
      "security_deposit": 200.00,
      "late_fee_per_hour": 15.00
    },
    "status": {
      "is_available": true,
      "current_odometer_reading": 15000
    },
    "media": {
      "images": ["https://example.com/car1.jpg", "https://example.com/car2.jpg"]
    },
    "created_at": "2023-04-19T12:00:00Z",
    "updated_at": "2023-04-19T12:00:00Z"
  }
}
```

### Get All Cars

Retrieve a list of all cars.

- **URL**: `/api/cars`
- **Method**: `GET`
- **Auth Required**: Yes

**Query Parameters:**

- `page` (optional): Page number for pagination (default: 1)
- `limit` (optional): Number of items per page (default: 10)
- `sort` (optional): Field to sort by (e.g., "make", "created_at")
- `order` (optional): Sort order, "asc" or "desc" (default: "asc")
- `make` (optional): Filter by car make
- `model` (optional): Filter by car model
- `min_year` (optional): Filter by minimum year
- `max_year` (optional): Filter by maximum year
- `fuel_type` (optional): Filter by fuel type
- `transmission` (optional): Filter by transmission type
- `body_type` (optional): Filter by body type

**Response:**

```json
{
  "success": true,
  "message": "Cars retrieved successfully",
  "data": {
    "cars": [
      {
        "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
        "make": "Toyota",
        "model": "Camry",
        "year": 2023,
        "variant": "XLE",
        "fuel_type": "Petrol",
        "transmission": "Automatic",
        "body_type": "Sedan",
        "color": "Silver",
        "seating_capacity": 5,
        "vehicle_number": "ABC123",
        "owner": {
          "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
          "name": "John Smith"
        },
        "status": {
          "is_available": true
        },
        "rental_info": {
          "rental_price_per_day": 50.00
        },
        "created_at": "2023-04-19T12:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 45,
      "limit": 10
    }
  }
}
```

### Get Available Cars

Retrieve a list of cars that are currently available for booking.

- **URL**: `/api/cars/available`
- **Method**: `GET`
- **Auth Required**: Yes

**Query Parameters:**
- Same as "Get All Cars" endpoint plus:
- `start_date` (optional): Start date for availability check (ISO8601 format)
- `end_date` (optional): End date for availability check (ISO8601 format)

**Response:**
- Same format as "Get All Cars" endpoint

### Get Car by ID

Retrieve details for a specific car.

- **URL**: `/api/cars/:id`
- **Method**: `GET`
- **Auth Required**: Yes

**Response:**

```json
{
  "success": true,
  "message": "Car retrieved successfully",
  "data": {
    "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "make": "Toyota",
    "model": "Camry",
    "year": 2023,
    "variant": "XLE",
    "fuel_type": "Petrol",
    "transmission": "Automatic",
    "body_type": "Sedan",
    "color": "Silver",
    "seating_capacity": 5,
    "vehicle_number": "ABC123",
    "owner": {
      "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      "name": "John Smith",
      "contact_info": "+1234567890"
    },
    "rental_info": {
      "rental_price_per_day": 50.00,
      "rental_price_per_hour": 10.00,
      "minimum_rent_duration": 4,
      "security_deposit": 200.00,
      "late_fee_per_hour": 15.00
    },
    "status": {
      "is_available": true,
      "current_odometer_reading": 15000,
      "damages_or_issues": "Minor scratch on rear bumper"
    },
    "media": {
      "images": ["https://example.com/car1.jpg", "https://example.com/car2.jpg"]
    },
    "created_at": "2023-04-19T12:00:00Z",
    "updated_at": "2023-04-19T12:00:00Z"
  }
}
```

### Update Car

Update details for a specific car.

- **URL**: `/api/cars/:id`
- **Method**: `PUT`
- **Auth Required**: Yes
- **Content-Type**: `application/json`

**Request Body:**
- Same structure as "Create a Car" endpoint, with fields to be updated

**Response:**
- Same structure as "Get Car by ID" endpoint, with updated information

### Delete Car

Delete a specific car from the system.

- **URL**: `/api/cars/:id`
- **Method**: `DELETE`
- **Auth Required**: Yes

**Response:**

```json
{
  "success": true,
  "message": "Car deleted successfully",
  "data": null
}
```

## Booking Management

### Create a Booking

Create a new booking for a car.

- **URL**: `/api/bookings`
- **Method**: `POST`
- **Auth Required**: Yes
- **Content-Type**: `application/json`

**Request Body:**

```json
{
  "car_id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
  "start_time": "2023-04-20T10:00:00Z",
  "end_time": "2023-04-25T10:00:00Z"
}
```

**Response:**

```json
{
  "success": true,
  "message": "Booking created successfully",
  "data": {
    "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "user": {
      "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      "name": "John Doe"
    },
    "car": {
      "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      "make": "Toyota",
      "model": "Camry",
      "year": 2023,
      "color": "Silver",
      "vehicle_number": "ABC123"
    },
    "start_time": "2023-04-20T10:00:00Z",
    "end_time": "2023-04-25T10:00:00Z",
    "status": "BOOKED",
    "total_price": 250.00,
    "created_at": "2023-04-19T12:00:00Z"
  }
}
```

### Get Booking by ID

Retrieve details for a specific booking.

- **URL**: `/api/bookings/:id`
- **Method**: `GET`
- **Auth Required**: Yes

**Response:**

```json
{
  "success": true,
  "message": "Booking retrieved successfully",
  "data": {
    "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "user": {
      "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      "name": "John Doe",
      "email": "john@example.com"
    },
    "car": {
      "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
      "make": "Toyota",
      "model": "Camry",
      "year": 2023,
      "color": "Silver",
      "vehicle_number": "ABC123"
    },
    "start_time": "2023-04-20T10:00:00Z",
    "end_time": "2023-04-25T10:00:00Z",
    "status": "BOOKED",
    "total_price": 250.00,
    "created_at": "2023-04-19T12:00:00Z",
    "updated_at": "2023-04-19T12:00:00Z"
  }
}
```

### Cancel Booking

Cancel a specific booking.

- **URL**: `/api/bookings/:id`
- **Method**: `DELETE`
- **Auth Required**: Yes

**Response:**

```json
{
  "success": true,
  "message": "Booking cancelled successfully",
  "data": null
}
```

### Get User Bookings

Retrieve all bookings for a specific user.

- **URL**: `/api/users/:userId/bookings`
- **Method**: `GET`
- **Auth Required**: Yes

**Query Parameters:**

- `page` (optional): Page number for pagination (default: 1)
- `limit` (optional): Number of items per page (default: 10)
- `status` (optional): Filter by booking status ("BOOKED", "CANCELLED", "COMPLETED")

**Response:**

```json
{
  "success": true,
  "message": "User bookings retrieved successfully",
  "data": {
    "bookings": [
      {
        "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
        "car": {
          "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
          "make": "Toyota",
          "model": "Camry",
          "year": 2023,
          "color": "Silver",
          "vehicle_number": "ABC123"
        },
        "start_time": "2023-04-20T10:00:00Z",
        "end_time": "2023-04-25T10:00:00Z",
        "status": "BOOKED",
        "total_price": 250.00,
        "created_at": "2023-04-19T12:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 3,
      "total_items": 25,
      "limit": 10
    }
  }
}
```

## Owner Management

### Create an Owner

Add a new car owner to the system.

- **URL**: `/api/owners`
- **Method**: `POST`
- **Auth Required**: Yes
- **Content-Type**: `application/json`

**Request Body:**

```json
{
  "name": "John Smith",
  "contact_info": "john@example.com"
}
```

**Response:**

```json
{
  "success": true,
  "message": "Owner created successfully",
  "data": {
    "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "name": "John Smith",
    "contact_info": "john@example.com",
    "created_at": "2023-04-19T12:00:00Z",
    "updated_at": "2023-04-19T12:00:00Z"
  }
}
```

### Get All Owners

Retrieve a list of all car owners.

- **URL**: `/api/owners`
- **Method**: `GET`
- **Auth Required**: Yes

**Query Parameters:**

- `page` (optional): Page number for pagination (default: 1)
- `limit` (optional): Number of items per page (default: 10)

**Response:**

```json
{
  "success": true,
  "message": "Owners retrieved successfully",
  "data": {
    "owners": [
      {
        "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
        "name": "John Smith",
        "contact_info": "john@example.com",
        "created_at": "2023-04-19T12:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 2,
      "total_items": 15,
      "limit": 10
    }
  }
}
```

### Get Owner by ID

Retrieve details for a specific owner.

- **URL**: `/api/owners/:id`
- **Method**: `GET`
- **Auth Required**: Yes

**Response:**

```json
{
  "success": true,
  "message": "Owner retrieved successfully",
  "data": {
    "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "name": "John Smith",
    "contact_info": "john@example.com",
    "cars": [
      {
        "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
        "make": "Toyota",
        "model": "Camry",
        "year": 2023,
        "vehicle_number": "ABC123"
      }
    ],
    "created_at": "2023-04-19T12:00:00Z",
    "updated_at": "2023-04-19T12:00:00Z"
  }
}
```

### Update Owner

Update details for a specific owner.

- **URL**: `/api/owners/:id`
- **Method**: `PUT`
- **Auth Required**: Yes
- **Content-Type**: `application/json`

**Request Body:**

```json
{
  "name": "John Smith",
  "contact_info": "john.smith@example.com"
}
```

**Response:**

```json
{
  "success": true,
  "message": "Owner updated successfully",
  "data": {
    "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "name": "John Smith",
    "contact_info": "john.smith@example.com",
    "created_at": "2023-04-19T12:00:00Z",
    "updated_at": "2023-04-19T13:00:00Z"
  }
}
```

### Delete Owner

Delete a specific owner from the system.

- **URL**: `/api/owners/:id`
- **Method**: `DELETE`
- **Auth Required**: Yes

**Response:**

```json
{
  "success": true,
  "message": "Owner deleted successfully",
  "data": null
}
```

## Error Responses

The API uses consistent error response formats:

### Validation Error

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": ["Email is required", "Password must be at least 6 characters"]
}
```

### Not Found Error

```json
{
  "success": false,
  "message": "Resource not found",
  "error": "The requested car does not exist"
}
```

### Unauthorized Error

```json
{
  "success": false,
  "message": "Unauthorized",
  "error": "Invalid or expired token"
}
```

### Server Error

```json
{
  "success": false,
  "message": "Internal server error",
  "error": "An unexpected error occurred"
}
```

## Data Models

### User

```json
{
  "id": "UUID",
  "name": "string",
  "email": "string",
  "password_hash": "string (not returned in responses)",
  "created_at": "datetime",
  "updated_at": "datetime",
  "deleted_at": "datetime | null"
}
```

### Car

```json
{
  "id": "UUID",
  "make": "string",
  "model": "string",
  "year": "integer",
  "variant": "string",
  "fuel_type": "string (Petrol, Diesel, Electric, Hybrid)",
  "transmission": "string (Manual, Automatic, CVT)",
  "body_type": "string (Sedan, SUV, Hatchback, Coupe, Van, Truck)",
  "color": "string",
  "seating_capacity": "integer",
  "vehicle_number": "string",
  "owner_id": "UUID (reference to Owner)",
  "created_at": "datetime",
  "updated_at": "datetime",
  "deleted_at": "datetime | null"
}
```

### Car Rental Info

```json
{
  "id": "UUID",
  "car_id": "UUID (reference to Car)",
  "rental_price_per_day": "decimal",
  "rental_price_per_hour": "decimal",
  "minimum_rent_duration": "integer",
  "security_deposit": "decimal",
  "late_fee_per_hour": "decimal",
  "rental_extend_fee_per_day": "decimal",
  "rental_extend_fee_per_hour": "decimal",
  "created_at": "datetime",
  "updated_at": "datetime",
  "deleted_at": "datetime | null"
}
```

### Booking

```json
{
  "id": "UUID",
  "user_id": "UUID (reference to User)",
  "car_id": "UUID (reference to Car)",
  "start_time": "datetime",
  "end_time": "datetime",
  "status": "string (BOOKED, CANCELLED, COMPLETED)",
  "total_price": "decimal",
  "created_at": "datetime",
  "updated_at": "datetime",
  "deleted_at": "datetime | null"
}
```

### Owner

```json
{
  "id": "UUID",
  "name": "string",
  "contact_info": "string",
  "created_at": "datetime",
  "updated_at": "datetime",
  "deleted_at": "datetime | null"
}
``` 