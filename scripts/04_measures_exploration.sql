/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    Calculate and explore aggregated business metrics (totals, averages) to 
    gain quick insights and identify overall trends or anomalies.

SQL Aggregate Functions Used:
    COUNT()  - Count records or distinct values
    SUM()    - Sum numeric values
    AVG()    - Calculate average values
===============================================================================
*/

-- Total revenue generated
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Total quantity of items sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Average price per item
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Total number of orders (note: COUNT includes duplicates, DISTINCT eliminates them)
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Total unique products in catalog
SELECT COUNT(product_name) AS total_products FROM gold.dim_products

-- Total unique customers in system
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Customers who have placed at least one order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Business Dashboard: All key metrics in a single report
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;
