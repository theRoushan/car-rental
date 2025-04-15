# Car Rental API Postman Collection

This directory contains an updated Postman collection for testing the Car Rental backend API.

## Features

- Complete coverage of all API endpoints
- Environment variables for easier testing
- Test scripts to automatically capture tokens and IDs
- Organized by resource type for better navigation

## Getting Started

### Importing the Collection

1. Open Postman
2. Click "Import" in the top left
3. Select the `car_rental_api_collection.json` file
4. The collection will be added to your Postman workspace

### Setting Up Environment Variables

Create a new environment in Postman with the following variables:

- `base_url`: The base URL of your API (default: http://localhost:8080)
- `token`: Will be automatically set after login
- `user_id`: Will be automatically set after login
- `car_id`: Will be automatically set after creating a car
- `booking_id`: Will be automatically set after creating a booking
- `owner_id`: Will be automatically set after creating an owner

## Using the Collection

### Authentication Flow

1. Register a user using the "Register User" request
2. Login with the registered credentials using the "Login User" request
   - This will automatically set the `token` and `user_id` variables

### Testing Endpoints

The endpoints are organized into the following folders:

1. **Authentication**
   - Register User
   - Login User

2. **Cars**
   - Create Car
   - Get All Cars
   - Get Car by ID
   - Update Car
   - Delete Car
   - Get Available Cars

3. **Bookings**
   - Create Booking
   - Get Booking by ID
   - Cancel Booking

4. **User Bookings**
   - Get User Bookings

5. **Owners**
   - Create Owner
   - Get All Owners
   - Get Owner by ID
   - Update Owner
   - Delete Owner

## Notes

- All protected endpoints automatically include the Authorization header with the JWT token
- Test scripts in key requests automatically capture and set IDs for subsequent requests
- The owner endpoints were added to the updated collection (previously missing) 