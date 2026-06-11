/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - Understand what portion each category represents of the total sales
    - Identify top-performing categories by contribution percentage
    - Compare category performance relative to overall business metrics

SQL Functions Used:
    - SUM(): Calculates total sales per category and overall total
    - Window Functions: SUM() OVER() to compute running totals across all rows
===============================================================================
*/

-- Query: Which categories contribute the most to overall sales?
-- Output: Shows each category's sales amount and percentage of total
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    -- Calculate percentage contribution of each category to total sales
    ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
