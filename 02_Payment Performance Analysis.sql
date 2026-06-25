--Task 2 - Payment Performance Analysis
--1 Payment Success Rate
SELECT 
COUNT(order_id)  AS total_orders
, SUM(CASE WHEN message_id = 1 THEN 1 ELSE 0 END) AS successful_orders
, SUM(CASE WHEN message_id <> 1  THEN 1 ELSE 0 END) AS failed_orders
, ROUND( SUM(CASE WHEN message_id = 1 THEN 1 ELSE 0 END)/ CAST(COUNT(order_id) AS FLOAT)*100,2) AS success_rate_pct
, ROUND( SUM(CASE WHEN message_id <> 1  THEN 1 ELSE 0 END)/CAST(COUNT(order_id) AS FLOAT)*100,2) AS failed_rate_pct
FROM (SELECT * FROM payment_history_17 UNION  ALL SELECT * FROM payment_history_18) AS  his 
;

--2 Success Rate by Category
SELECT category
, COUNT(order_id) AS total_orders
, SUM(CASE WHEN message_id = 1 THEN 1 ELSE 0 END) AS successful_orders
, SUM(CASE WHEN message_id <> 1 THEN 1 ELSE 0 END) AS failed_orders
,ROUND( SUM(CASE WHEN message_id = 1 THEN 1 ELSE 0 END) / CAST (COUNT(order_id) AS FLOAT) *100,2) AS success_rate_pct
, ROUND( SUM(CASE WHEN message_id <> 1 THEN 1 ELSE 0 END)/  CAST (COUNT(order_id) AS FLOAT)*100,2) AS failed_rate_pct
FROM (SELECT * FROM payment_history_17 UNION  ALL SELECT * FROM payment_history_18) AS  his 
LEFT JOIN product AS pro  
ON his.product_id = pro.product_number
GROUP BY category
;

--3 Failure Reason Analysis
SELECT mes.message_id ,  mes.description
, COUNT (order_id) AS total_failed_orders
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS  his 
LEFT JOIN table_message AS mes 
ON his.message_id = mes.message_id
WHERE mes.message_id <> 1
GROUP BY mes.message_id,  mes.description
ORDER BY total_failed_orders DESC
;

--4 Top Failure Reason by Category
WITH table_joined AS (
SELECT pro.category ,  mes.description
, COUNT (order_id) AS total_failed_orders
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS  his 
LEFT JOIN product AS pro  
ON his.product_id = pro.product_number
LEFT JOIN table_message AS mes 
ON his.message_id = mes.message_id
WHERE mes.message_id <> 1
GROUP BY pro.category,  mes.description
)
, rank_table AS (
SELECT *
, ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_failed_orders DESC) AS rank_number 
FROM table_joined
)
SELECT *
FROM rank_table
WHERE rank_number = 1

/*
BUSINESS INSIGHTS

1. The platform maintained a healthy transaction success rate of 86.45%.

2. Marketplace was the best-performing category with a success rate above 95%.

3. Transportation experienced the highest operational risk,
recording the lowest success rate among all categories.

4. Payment Failed was the dominant failure reason across most categories,
making it the primary target for performance improvement.

5. Failure patterns differ across categories,
suggesting that operational improvements should be tailored to specific business segments.
*/