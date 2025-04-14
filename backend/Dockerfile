# Build stage
FROM golang:1.24-alpine AS builder

WORKDIR /build

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application and migration tool
RUN CGO_ENABLED=0 GOOS=linux go build -o bin/main ./cmd/api
RUN CGO_ENABLED=0 GOOS=linux go build -o bin/migrate ./bin/migrate.go

# Final stage
FROM golang:1.24-alpine

WORKDIR /app

# Create necessary directories
RUN mkdir -p /app/bin /app/migrations

# Copy binaries and make them executable
COPY --from=builder /build/bin/main /app/bin/
COPY --from=builder /build/bin/migrate /app/bin/
RUN chmod +x /app/bin/main /app/bin/migrate

# Copy environment file and migrations
COPY --from=builder /build/.env /app/
COPY --from=builder /build/migrations /app/migrations/

# Expose port
EXPOSE 8080

# Run the application
CMD ["/app/bin/main"] 