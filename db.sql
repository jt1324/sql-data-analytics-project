-- SQLite database file: datawarehouseanalytics.db
-- SQLite has no gold schema, so these are the three tables from 00_init_database.sql.

CREATE TABLE IF NOT EXISTS dim_customers (
    customer_key INTEGER,
    customer_id INTEGER,
    customer_number TEXT,
    first_name TEXT,
    last_name TEXT,
    country TEXT,
    marital_status TEXT,
    gender TEXT,
    birthdate TEXT,
    create_date TEXT
);

CREATE TABLE IF NOT EXISTS dim_products (
    product_key INTEGER,
    product_id INTEGER,
    product_number TEXT,
    product_name TEXT,
    category_id TEXT,
    category TEXT,
    subcategory TEXT,
    maintenance TEXT,
    cost INTEGER,
    product_line TEXT,
    start_date TEXT
);

CREATE TABLE IF NOT EXISTS fact_sales (
    order_number TEXT,
    product_key INTEGER,
    customer_key INTEGER,
    order_date TEXT,
    shipping_date TEXT,
    due_date TEXT,
    sales_amount INTEGER,
    quantity INTEGER,
    price INTEGER
);
