--Task 7 - Promotion Cost Distribution by Customer Activity Level
WITH table_joined AS (
SELECT customer_id
, COUNT(order_id) AS total_orders
, SUM(CAST(discount_price AS BIGINT)) AS discount_total
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1 AND promotion_id <> '0'
GROUP BY customer_id
)
, percentrank_table AS (
SELECT *
, PERCENT_RANK() OVER (ORDER BY total_orders DESC) AS [percentrank]
FROM table_joined 
)
, top_percentrank_table AS (
SELECT  ROUND(percentrank*100,0) AS activity_percentile
, SUM(total_orders) AS total_transactions
, COUNT(DISTINCT customer_id) AS number_customers
, MIN(total_orders) AS min_transactions
, SUM(discount_total) AS total_promotion_cost
FROM percentrank_table
GROUP BY ROUND(percentrank*100,0)
)
, accum_table AS (
SELECT *
, accummulative_customers = SUM(number_customers) OVER(ORDER BY activity_percentile ASC)
, accummulative_promotion_cost = SUM(total_promotion_cost) OVER(ORDER BY activity_percentile ASC)
FROM top_percentrank_table
)
SELECT 
activity_percentile
, CONCAT('Top ',ROUND(CAST(accummulative_customers AS FLOAT)/SUM(number_customers) OVER ()*100,0),'%') AS customer_percentile_group
, min_transactions
, number_customers
, total_transactions
, total_promotion_cost
, accummulative_customers
, accummulative_promotion_cost
, ROUND(CAST(accummulative_promotion_cost AS FLOAT)/SUM(total_promotion_cost) OVER ()*100,2) AS promotion_cost_share_pct
,CAST(accummulative_promotion_cost AS FLOAT)/ accummulative_customers AS avg_promotion_cost_per_customer
FROM accum_table

/* TASK 7 - PROMOTION COST DISTRIBUTION BY CUSTOMER ACTIVITY LEVEL

1. Promotion costs are highly concentrated among the most active customers. A relatively small group of high-frequency customers accounts for a disproportionately large share of total promotion spending.

2. Customer activity level strongly correlates with promotion cost consumption. Customers with more transactions receive significantly higher cumulative discount values than low-activity customers.

3. Average promotion cost per customer decreases as customer activity groups expand. The highest-activity customers receive the largest promotion investment per user, while lower-activity segments contribute less promotional cost on average.

4. Promotion spending is concentrated among highly active customers, suggesting that frequent users receive a larger share of promotional benefits.

5. Promotion costs are unevenly distributed across customer activity groups, with highly active customers accounting for a substantially larger share of total promotional spending.*/
