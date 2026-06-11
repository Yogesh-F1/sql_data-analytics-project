/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - Measure product, customer, or regional performance trends over time.
    - Identify and benchmark high-performing entities.
    - Track yearly trends and growth patterns.

SQL Functions Used:
    - LAG(): Accesses sales data from the previous year for comparison.
    - AVG() OVER(): Calculates average sales for each product across all years.
    - CASE: Determines whether performance is above, below, or at average.
===============================================================================
*/

/* Calculate total yearly sales per product, then compare each year to:
   1) The product's average sales across all years
   2) The previous year's sales (Year-over-Year growth) */
WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY 
        YEAR(f.order_date),
        p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    -- Compare current year to product average
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_from_avg,
    CASE 
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'At Avg'
    END AS performance_vs_avg,
    -- Compare current year to previous year (Year-over-Year analysis)
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prior_year_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS yoy_change,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS yoy_trend
FROM yearly_product_sales
ORDER BY product_name, order_year;
