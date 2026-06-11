/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    Explore the database structure by examining tables and their schemas to
    understand the data organization and column properties.

Reference Tables:
    - INFORMATION_SCHEMA.TABLES: Metadata about database tables
    - INFORMATION_SCHEMA.COLUMNS: Metadata about table columns
===============================================================================
*/

-- Get all tables in the database with their type and location
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

-- Get column details for the dim_customers table (names, data types, nullability)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
