CREATE TYPE car_creation_state AS ENUM (
    'basic_details',
    'owner_info',
    'location_details',
    'rental_info',
    'documents_media',
    'status_info',
    'completed'
);

CREATE TABLE car_creation_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    car_id UUID NOT NULL UNIQUE,
    state car_creation_state NOT NULL DEFAULT 'basic_details',
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
); 