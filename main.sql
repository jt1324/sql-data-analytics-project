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


-- Measures Exploration

SELECT
    printf('%,d', SUM(sales_amount)) AS total_sales,
    printf('%,d', SUM(quantity)) AS items_sold,
    printf('%,d', AVG(price)) AS avg_price,
    printf('%,d', COUNT(DISTINCT order_number)) AS num_of_orders,
    printf('%,d', COUNT(DISTINCT customer_key)) AS num_cutomers_orders
FROM fact_sales;

SELECT
    COUNT(DISTINCT product_name) AS num_of_products
FROM dim_products;

SELECT
    printf('%,d', COUNT(DISTINCT customer_key)) AS num_cutomers
FROM dim_customers;

-- Combining the results

SELECT
    'Total Sales' AS measure_name, printf('%,d', SUM(sales_amount)) AS measure_value
FROM fact_sales
UNION ALL
SELECT
    'Items Sold' AS measure_name, printf('%,d', SUM(quantity)) AS measure_value
FROM fact_sales
UNION ALL
SELECT
    'Avg Price' AS measure_name, printf('%,d', AVG(price)) AS measure_value
FROM fact_sales
UNION ALL
SELECT
    'Number of Orders' AS measure_name, printf('%,d', COUNT(DISTINCT order_number)) AS measure_value
FROM fact_sales
UNION ALL
SELECT
    'Number of Customers with Order' AS measure_name, printf('%,d', COUNT(DISTINCT customer_key)) AS measure_value
FROM fact_sales
UNION ALL
SELECT
    'Number of Products' AS measure_name, COUNT(DISTINCT product_name) AS measure_value
FROM dim_products
UNION ALL
SELECT
    'Number of Customers' AS measure_name, printf('%,d', COUNT(DISTINCT customer_key)) AS measure_value
FROM dim_customers


