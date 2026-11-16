/*
Create DataWarehouseAnalytics on PostgreSQL and load the gold tables.
This is the PostgreSQL version of 00_init_database.sql.
The original script is SQL Server syntax and points at CSV paths that
are not on this machine.

Run with psql, from any database:

    psql -U postgres -h localhost -d postgres -f 00_init_database_postgres.sql

Running this drops and recreates the datawarehouseanalytics database.
*/

\set ON_ERROR_STOP on
\encoding UTF8

\connect postgres

SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'datawarehouseanalytics'
  AND pid <> pg_backend_pid();

DROP DATABASE IF EXISTS datawarehouseanalytics;

CREATE DATABASE datawarehouseanalytics;

\connect datawarehouseanalytics
\encoding UTF8

CREATE SCHEMA gold;

CREATE TABLE gold.dim_customers (
    customer_key int,
    customer_id int,
    customer_number varchar(50),
    first_name varchar(50),
    last_name varchar(50),
    country varchar(50),
    marital_status varchar(50),
    gender varchar(50),
    birthdate date,
    create_date date
);

CREATE TABLE gold.dim_products (
    product_key int,
    product_id int,
    product_number varchar(50),
    product_name varchar(50),
    category_id varchar(50),
    category varchar(50),
    subcategory varchar(50),
    maintenance varchar(50),
    cost int,
    product_line varchar(50),
    start_date date
);

CREATE TABLE gold.fact_sales (
    order_number varchar(50),
    product_key int,
    customer_key int,
    order_date date,
    shipping_date date,
    due_date date,
    sales_amount int,
    quantity smallint,
    price int
);

\copy gold.dim_customers FROM 'C:/Users/jeant/Documents/2026/SQL/Projects/sql-data-analytics-project/sql-data-analytics-project/datasets/flat-files/dim_customers.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy gold.dim_products FROM 'C:/Users/jeant/Documents/2026/SQL/Projects/sql-data-analytics-project/sql-data-analytics-project/datasets/flat-files/dim_products.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy gold.fact_sales FROM 'C:/Users/jeant/Documents/2026/SQL/Projects/sql-data-analytics-project/sql-data-analytics-project/datasets/flat-files/fact_sales.csv' WITH (FORMAT csv, HEADER true, NULL '')

SELECT 'dim_customers' AS table_name, COUNT(*) AS row_count FROM gold.dim_customers
UNION ALL
SELECT 'dim_products', COUNT(*) FROM gold.dim_products
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM gold.fact_sales;
