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

