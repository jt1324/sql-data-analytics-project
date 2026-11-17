# Sales Data Exploration – SQL

An exploratory data analysis (EDA) of a retail sales dataset using **SQLite**. The project works through the data step by step: its structure, dimensions, dates, key measures, magnitude breakdowns and rankings.

## Objective

Get to know the dataset and answer core business questions, such as how much was sold, who buys, where they're based, and which products and customers bring in the most revenue.

## Data Model

The dataset uses a **star schema** with one fact table and two dimension tables:

| Table | Type | Description |
|---|---|---|
| `fact_sales` | Fact | Sales transactions with order number, order date, quantity, price and sales amount |
| `dim_customers` | Dimension | Customer details such as name, country, gender and birthdate |
| `dim_products` | Dimension | Product details such as name, category, subcategory and cost |

`fact_sales` links to the dimensions through `customer_key` and `product_key`.

## Analysis Steps

### 1. Data Exploration
A first look at each table to understand its columns and contents.

### 2. Dimensions Exploration
- The countries customers come from
- The product hierarchy of category, subcategory and product

### 3. Date Exploration
- The first and last order dates, and the number of months between them
- The oldest and youngest customers, with their ages

### 4. Measures Exploration
The key business figures:
- Total sales
- Items sold
- Average price
- Number of orders
- Number of customers who placed an order
- Number of products
- Total number of customers

These are combined into a single report with `UNION ALL`, laid out as two columns: `measure_name` and `measure_value`.

### 5. Magnitude Analysis
Measures compared across dimensions:
- Customers by country and by gender
- Products by category, and average cost by category
- Revenue by category and by customer
- Items sold by country

### 6. Ranking Analysis
- The top 5 and bottom 5 products by revenue, using `ORDER BY` + `LIMIT`
- The top 5 products using `ROW_NUMBER()`
- The top 10 and bottom 3 customers by revenue, combined into one result

## SQL Techniques Used

- `SELECT DISTINCT`, `GROUP BY` and aggregates (`SUM`, `AVG`, `COUNT`, `MIN`, `MAX`)
- `LEFT JOIN` between fact and dimension tables
- Date handling with `strftime` and `date('now')`
- Number formatting with `printf('%,d', ...)`
- `UNION ALL` to build a summary report
- The window function `ROW_NUMBER()` in subqueries for rankings
- String concatenation with `||`

## How to Run

1. Import the CSV files into a SQLite database. For example:
   ```
   sqlite3 sales.db
   .mode csv
   .import dim_customers.csv dim_customers
   .import dim_products.csv dim_products
   .import fact_sales.csv fact_sales
   ```
2. Run the script from PowerShell:
   ```
   Get-Content main.sql | sqlite3 -header -column sales.db
   ```
   You can also run each section on its own in Cursor or any SQLite tool.

## Key Skills Demonstrated

- Exploring a star-schema dataset in a structured way
- Turning raw data into business KPIs
- Comparing measures across dimensions
- Ranking with window functions
