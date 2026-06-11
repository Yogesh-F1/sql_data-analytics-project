
/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    Explore the structure and content of dimension tables to understand 
    available data for analysis.
	
SQL Functions Used:
    - DISTINCT (eliminate duplicate values)
    - ORDER BY (sort results alphabetically)
===============================================================================
*/

-- Query 1: List all unique customer countries (sorted alphabetically)
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;

-- Query 2: List all unique product hierarchies (category > subcategory > product)
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
