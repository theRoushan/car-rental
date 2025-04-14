#!/bin/bash

# Exit on error
set -e

echo "🚀 Deploying Car Rental Backend..."

# Build the Docker image
echo "🐳 Building Docker image..."
docker-compose build

# Start the services
echo "🚀 Starting services..."
docker-compose up -d postgres

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
until docker-compose exec -T postgres pg_isready -U postgres; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done

echo "PostgreSQL is up - running migrations"

# Set environment variables for migrations
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=postgres
export DB_PASSWORD=postgres
export DB_NAME=car_rental
export DB_SSL_MODE=disable

# Run migrations
echo "🔄 Running database migrations..."
go run bin/migrate.go -up

echo "Starting app"
docker-compose up -d app

echo "✅ Deployment completed successfully!"
echo "🌐 API is available at http://localhost:8080" 