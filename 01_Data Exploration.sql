--Task 1: Data Exploration
--1 Data Quality Check
SELECT  COUNT(DISTINCT customer_id) AS total_cus
, COUNT(order_id) AS total_orders
, COUNT( DISTINCT product_id) AS total_product
, SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customers
,SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_orders
,SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS null_transaction_date
,SUM(CASE WHEN final_price IS NULL THEN 1 ELSE 0 END) AS null_final_price
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his  
;
--2 Duplicate Check

SELECT order_id
, COUNT(*) AS duplicate_order
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his  
GROUP BY order_id 
HAVING  COUNT(*) > 1
;
--3 Transaction Status Distribution

SELECT message_id
, COUNT(message_id) AS total_transaction
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his  
GROUP BY message_id
;
--4 Transaction Volume by Category

SELECT sub_category
, COUNT(DISTINCT order_id) AS total_transaction
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his  
LEFT JOIN product AS pro  
ON his.product_id = pro.product_number
GROUP BY sub_category
ORDER BY total_transaction DESC  
;
--5 Transaction Trend   

SELECT YEAR(transaction_date) AS [year], MONTH(transaction_date) AS [month]
, COUNT(order_id) AS total_transaction
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his  
GROUP BY YEAR(transaction_date), MONTH(transaction_date)
ORDER BY [year],[month] ASC
;
--6 Revenue Overview

SELECT 
SUM(CAST (final_price AS BIGINT)) AS total_revenue
,AVG(CAST (final_price AS BIGINT)) AS avg_price_orders
, MIN(CAST (final_price AS BIGINT)) AS min_price_orders
, MAX(CAST (final_price AS BIGINT)) AS max_price_orders
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his  
WHERE message_id = 1
;
--7 Revenue by Category

SELECT sub_category
, SUM(CAST (final_price AS BIGINT)) AS total_revenue
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his  
LEFT JOIN product AS pro  
ON his.product_id = pro.product_number
WHERE message_id = 1
GROUP BY sub_category
ORDER BY total_revenue DESC
;
--8 Category Performance

SELECT sub_category
, COUNT( order_id) AS total_transaction
, COUNT(DISTINCT customer_id) AS total_customers
, SUM(CAST(final_price AS BIGINT)) AS total_revenue
, AVG(CAST(final_price AS BIGINT)) AS avg_price_orders
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his  
LEFT JOIN product AS pro  
ON his.product_id = pro.product_number
WHERE message_id = 1
GROUP BY sub_category
ORDER BY total_revenue DESC

/*INSIGHT:
1. No missing values were found in key business fields, indicating good data quality.

2. No duplicate order IDs were detected, suggesting transaction records are unique.

3. Electricity generated the highest revenue among all categories, making it the primary revenue contributor.

4. Telco Card recorded the largest transaction volume, indicating frequent customer usage.

5. Electricity services exhibited significantly higher average order values than telecom-related services.

6. High transaction volume does not necessarily translate into high revenue, as revenue is heavily influenced by average transaction value.