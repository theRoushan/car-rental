# Database Migrations

This directory contains database migration files for the car rental application.

## Migration Files

Each migration consists of two files:
- `<name>.up.sql`: Contains the SQL to apply the migration
- `<name>.down.sql`: Contains the SQL to revert the migration

## Current Migrations

1. `001_initial_schema`: Creates the initial database schema with all tables and relationships
2. `002_add_admin_user`: Adds an initial admin user to the database
3. `003_sample_data`: Adds sample data to the database for testing purposes

## Creating New Migrations

To create a new migration, run the following command from the project root:

```bash
./bin/create_migration.sh <migration_name>
```

This will create two new files in the migrations directory:
- `<timestamp>_<migration_name>.up.sql`
- `<timestamp>_<migration_name>.down.sql`

Edit these files to add your migration logic.

## Running Migrations

To apply all pending migrations:

```bash
go run bin/migrate.go -up
```

To revert all migrations:

```bash
go run bin/migrate.go -down
```

## Best Practices

1. Always create both UP and DOWN migrations
2. Make migrations idempotent (can be run multiple times without error)
3. Keep migrations small and focused on a single change
4. Document complex migrations with comments
5. Test migrations in a development environment before applying them to production 