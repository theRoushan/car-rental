#!/bin/bash

# Check if a migration name was provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <migration_name> [prefix]"
    echo "Example: $0 add_users 002"
    exit 1
fi

MIGRATION_NAME=$1
PREFIX=""

# Check if a prefix was provided
if [ $# -eq 2 ]; then
    PREFIX="${2}_"
fi

# Get current date and time in format YYYYMMDDHHMMSS
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Create the migration file name
if [ -n "$PREFIX" ]; then
    UP_MIGRATION_FILE="migrations/${PREFIX}${MIGRATION_NAME}.up.sql"
    DOWN_MIGRATION_FILE="migrations/${PREFIX}${MIGRATION_NAME}.down.sql"
else
    UP_MIGRATION_FILE="migrations/${TIMESTAMP}_${MIGRATION_NAME}.up.sql"
    DOWN_MIGRATION_FILE="migrations/${TIMESTAMP}_${MIGRATION_NAME}.down.sql"
fi

# Check if migrations directory exists, if not create it
if [ ! -d "migrations" ]; then
    mkdir -p migrations
    echo "Created migrations directory"
fi

# Check if migration files already exist
if [ -f "$UP_MIGRATION_FILE" ] || [ -f "$DOWN_MIGRATION_FILE" ]; then
    echo "Error: Migration files already exist with this name and prefix"
    exit 1
fi

# Create the up migration file
cat > "$UP_MIGRATION_FILE" << EOF
-- Migration: $MIGRATION_NAME
-- Created at: $(date)
-- Description: 

BEGIN;

-- Your SQL statements here

COMMIT;
EOF

# Create the down migration file
cat > "$DOWN_MIGRATION_FILE" << EOF
-- Migration: $MIGRATION_NAME (rollback)
-- Created at: $(date)
-- Description:

BEGIN;

-- Your SQL statements here to undo the changes

COMMIT;
EOF

echo "Created migration files:"
echo "  - $UP_MIGRATION_FILE"
echo "  - $DOWN_MIGRATION_FILE" 