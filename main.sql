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


-- Magnitude Analysis

SELECT 
    country,
    printf('%,d', COUNT(DISTINCT( customer_id))) AS qty_customers
FROM dim_customers
GROUP BY country
ORDER BY 2 DESC;

SELECT 
    DISTINCT gender,
    printf('%,d', COUNT(DISTINCT( customer_id))) AS qty_customers
FROM dim_customers
GROUP BY gender
ORDER BY 2 DESC;

SELECT 
    DISTINCT category,
    printf('%,d', COUNT(DISTINCT( product_id))) AS qty_products
FROM dim_products
GROUP BY category
ORDER BY 2 DESC;

SELECT 
    DISTINCT category,
    printf('%,d', AVG( cost)) AS avg_cost
FROM dim_products
GROUP BY category
ORDER BY 2 DESC;

SELECT
    p.category,
    printf('%,d', SUM(s.sales_amount)) AS revenue
FROM fact_sales s
LEFT JOIN dim_products p
    ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY s.sales_amount DESC;

SELECT
    c.customer_key,
    (c.first_name || ' ' || c.last_name) AS customer_name,
    printf('%,d', SUM(s.sales_amount)) AS revenue    
FROM fact_sales s
    LEFT JOIN dim_customers c
        ON s.customer_key = c.customer_key
GROUP BY c.customer_key
ORDER BY SUM(s.sales_amount) DESC;

SELECT
    c.country,
    printf('%,d', SUM(s.quantity)) AS sold_items
FROM fact_sales s
    LEFT JOIN dim_customers c
        ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY SUM(s.quantity) DESC;


-- Ranking analysis

SELECT
    p.product_name AS product,
    printf('%,d', SUM(s.sales_amount)) AS revenue
FROM fact_sales s
    LEFT JOIN dim_products p
        ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY SUM(s.sales_amount) DESC
LIMIT 5;

SELECT
    p.product_name AS product,
    printf('%,d', SUM(s.sales_amount)) AS revenue
FROM fact_sales s
    LEFT JOIN dim_products p
        ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY SUM(s.sales_amount) 
LIMIT 5;

SELECT
    *
FROM (
    SELECT
        p.product_name AS product,
        printf('%,d', SUM(s.sales_amount)) AS revenue,
        ROW_NUMBER() OVER( ORDER BY SUM(s.sales_amount) DESC
        ) AS rank
    FROM fact_sales s
        LEFT JOIN dim_products p
            ON s.product_key = p.product_key
    GROUP BY p.product_name)
WHERE rank <= 5;

SELECT
    *
FROM (
    SELECT
        c.customer_key,
        (c.first_name || ' ' || c.last_name) AS customer,
        printf('%,d', SUM(s.sales_amount)) AS revenue,
        ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC
        ) AS rank
    FROM fact_sales s
        LEFT JOIN dim_customers c
            ON s.customer_key = c.customer_key
    GROUP BY c.customer_key)
WHERE rank <= 10

UNION ALL

SELECT
    *
FROM (
    SELECT
        c.customer_key,
        (c.first_name || ' ' || c.last_name) AS customer,
        printf('%,d', SUM(s.sales_amount)) AS revenue,
        ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount)
        ) AS rank
    FROM fact_sales s
        LEFT JOIN dim_customers c
            ON s.customer_key = c.customer_key
    GROUP BY c.customer_key)
WHERE rank <= 3;