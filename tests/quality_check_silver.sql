

--Check For NULLs or Duplicates in primary key
-- Expectation: No Result
SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL
--Check for unwanted spaces
--Expection: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

--Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT *
FROM silver.crm_cust_info

--CLEAN AND LOAD 



SELECT 
	prd_id,
	prd_key,
	prd_nm,
	prd_start_dt,
	CAST(prd_end_dt AS DATE) AS prd_end_dt,
	CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key 
		ORDER BY prd_start_dt) - 1 AS DATE)AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')
--updated table 


--check for invalid date orders
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

--Data Standardization & Consistency 
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info
--check for unwanted spaces
-- expectation: No results

SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)
--Check for NULLS or Negative Numbers
--Expectation : No Results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

WHERE SUBSTRING(prd_key, 7, LEN(prd_key)) IN (
SELECT sls_prd_key FROM bronze.crm_sales_details )

--to compare 
WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN 
(SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2)

--Check For Nulls or Duplicates in primary Key
--Expectation: No Result
SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


--Clean And Load 
-- Sales Details




SELECT *
FROM silver.crm_sales_details
--check data Consistancy : between sales ,quantity, and price
-->> Sales = Quantity * price
-->> Values muzt not be NULL, Zero, or Negative

SELECT DISTINCT
	sls_sales AS old_sls_value,
	sls_quantity,
	sls_price AS old_sls_price,
	CASE 
		WHEN sls_sales IS NULL OR sls_sales <= 0 
			OR sls_sales != sls_quantity * ABS(sls_price) 
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,
	CASE
		WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales / NULLIF(sls_quantity,0)
		ELSE sls_price
	END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL 
	OR sls_quantity IS NULL
	OR sls_price IS NULL
	OR sls_sales <= 0 
	OR sls_quantity IS NULL
	OR sls_price IS NULL
ORDER BY sls_sales, sls_quantity, sls_price


--WHERE sls_ord_num != TRIM(sls_ord_num)
--WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)

--Check Invalid Date
SELECT 
	NULLIF(sls_due_dt,0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <=  0 
	OR LEN(sls_due_dt) != 8 
	OR 	sls_due_dt > 20500101 
	OR sls_due_dt < 19000101

--invalid date order date then sales date earlier
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt



SELECT *
FROM silver.erp_cust_az12


SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry
--Data Standardization & Consistency
SELECT DISTINCT cntry as old_cntry,
	CASE
		WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101
ORDER BY cntry
--WHERE cid NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)
--WHERE cid LIKE '%AW00011000%'
SELECT *
FROM [silver].[crm_cust_info]
--Identify Out-of-Range Dates
SELECT DISTINCT
	bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1942-01-01' OR bdate >  GETDATE()
--Data standardization & Consistency
SELECT DISTINCT gen
FROM bronze.erp_cust_az12


--==================

SELECT *
FROM silver.erp_px_cat_g1v2

--check for unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat)
	OR maintenance != TRIM(maintenance)
--DATA Standardization & consistency
SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2


--==Create Stored Procedure===

