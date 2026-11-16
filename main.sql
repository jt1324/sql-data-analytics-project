-- Data Exploration

SELECT
    *
FROM dim_customers
LIMIT 100;

SELECT
    *
FROM dim_products
LIMIT 100;

SELECT
    *
FROM FACT_sales
LIMIT 100;


-- Dimensions exploration

SELECT
    DISTINCT country
FROM dim_customers;

SELECT
    DISTINCT category,
    subcategory,
    product_name
FROM dim_products
ORDER BY category;


-- Date exploration

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    (CAST(strftime('%Y', MAX(order_date)) AS INTEGER) * 12
     + CAST(strftime('%m', MAX(order_date)) AS INTEGER))
    - (CAST(strftime('%Y', MIN(order_date)) AS INTEGER) * 12
       + CAST(strftime('%m', MIN(order_date)) AS INTEGER)) AS order_range_months
FROM fact_sales;

SELECT
    MIN(birthdate) AS oldest_birthdate,
    CAST(strftime('%Y', date('now')) AS INTEGER)
        - CAST(strftime('%Y', MIN(birthdate)) AS INTEGER) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    CAST(strftime('%Y', date('now')) AS INTEGER)
        - CAST(strftime('%Y', MAX(birthdate)) AS INTEGER) AS youngest_age
FROM dim_customers;


