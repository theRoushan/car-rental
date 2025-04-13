# Build stage
FROM golang:1.24-alpine AS builder

WORKDIR /build

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./cmd/api

# Final stage
FROM golang:1.24-alpine

WORKDIR /app

# Create bin directory
RUN mkdir -p /app/bin

# Copy the binary and make it executable
COPY --from=builder /build/main /app/bin/
COPY --from=builder /build/.env /app/
RUN chmod +x /app/bin/main && ls -la /app/bin/

# Expose port
EXPOSE 8080

# Run the application
CMD ["/app/bin/main"] 