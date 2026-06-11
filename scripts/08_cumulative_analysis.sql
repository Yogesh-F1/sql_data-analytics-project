/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - Calculate running totals or moving averages for key metrics
    - Track performance metrics cumulatively over time
    - Identify long-term trends and growth patterns

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Aggregate sales by year and calculate running totals and moving averages
-- Running Total: Cumulative sum of sales from the beginning through each year
-- Moving Average: Average price across all periods up to each year
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT 
        DATETRUNC(year, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) t
