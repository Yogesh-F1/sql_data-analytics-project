/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - Group data into meaningful categories to identify patterns and trends.
    - Support targeted analysis for customer segmentation, product categories,
      regional performance, or other business dimensions.

SQL Functions Used:
    - CASE: Creates custom segmentation categories based on business rules.
    - GROUP BY: Aggregates data into segments for summary statistics.
===============================================================================
*/

-- Query 1: Product Cost Distribution
-- Categorizes products into cost ranges and counts products in each range
WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

-- Query 2: Customer Value Segmentation
-- Classifies customers into three groups based on engagement and spending:
--   • VIP: 12+ months tenure & spending > €5,000
--   • Regular: 12+ months tenure & spending ≤ €5,000
--   • New: Less than 12 months tenure
-- Returns the count of customers in each segment
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT 
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;
