/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - Quantify sales metrics and customer data by grouping across key dimensions
    - Understand data distribution and patterns across categories and regions

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- Customer Count by Country
-- Shows how many customers are based in each country, sorted by highest count
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Customer Count by Gender
-- Breakdown of total customers by gender
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Product Count by Category
-- Number of products available in each category
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Average Product Cost by Category
-- Calculate the average cost of products within each category to identify pricing tiers
SELECT
    category,
    AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- Total Revenue by Product Category
-- Revenue performance for each category to identify top-performing product lines
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Total Revenue by Customer
-- Lifetime revenue contribution from each customer; helps identify VIP customers
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- Total Units Sold by Country
-- Sales volume distribution by geography to assess market penetration
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;
