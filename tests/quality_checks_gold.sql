
SELECT 
	customer_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

SELECT 
	product_key,
	COUNT(*) AS duplicate_count
FROM gold.dime_products
GROUP BY product_key 
HAVING COUNT(*) > 1;

SELECT  *
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dime_products AS p
ON p.product_key = f.product_key
WHERE c.customer_key IS NULL
