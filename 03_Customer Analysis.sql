--Task 3 - Customer Analysis
--1 Top Customers by Revenue
 WITH table_joined AS (
SELECT customer_id
,COUNT(order_id) AS total_orders
, SUM(CAST(final_price AS BIGINT)) AS total_revenue
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT* FROM payment_history_18) AS his
WHERE message_id = 1
GROUP BY customer_id
)
SELECT TOP 20 *
FROM table_joined
ORDER BY total_revenue DESC
;

--2 Customer Revenue Ranking
WITH table_joined AS (
SELECT customer_id
, COUNT(order_id) AS total_orders
, SUM(CAST(final_price AS BIGINT)) AS total_revenue
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT* FROM payment_history_18) AS his
WHERE message_id = 1
GROUP BY customer_id
)
SELECT *
, RANK () OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM table_joined
;

--3 Customer Segmentation
WITH table_joined AS (
SELECT customer_id
, COUNT(order_id) AS total_orders
, SUM(CAST(final_price AS BIGINT)) AS total_revenue 
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT* FROM payment_history_18) AS his
WHERE message_id = 1
GROUP BY customer_id
)
, tile_table AS (
SELECT *
, NTILE(10) OVER(ORDER BY total_revenue DESC) AS tile
FROM table_joined
)
, segment_table AS (
SELECT *
, CASE WHEN tile = 1 THEN 'Vip'
WHEN tile BETWEEN 2 AND 3 THEN 'Gold'
WHEN tile BETWEEN 4 AND 6 THEN 'Silver'
ELSE 'Bronze'
END AS segment
FROM tile_table
)
, segment_value_table AS (
SELECT segment
, COUNT(customer_id) AS total_customers
, SUM(total_orders) AS total_segment_order
,SUM(CAST (total_revenue AS BIGINT)) AS total_segment_revenue
, AVG(CAST(total_revenue AS BIGINT)) AS avg_revenue_per_customer
FROM segment_table
GROUP BY segment
)
SELECT *
,ROUND(CAST (total_segment_revenue AS FLOAT)/ SUM(total_segment_revenue) OVER ()*100,2) AS revenue_share_pct
FROM segment_value_table
;
-- Alternative Approach using PERCENT_RANK()
WITH table_joined AS (
SELECT customer_id
, COUNT(order_id) AS total_orders
, SUM(CAST(final_price AS BIGINT)) AS total_revenue 
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT* FROM payment_history_18) AS his
WHERE message_id = 1
GROUP BY customer_id
)
, percentrank_table AS (
SELECT *
, PERCENT_RANK() OVER(ORDER BY total_revenue DESC) AS percentrank  
FROM table_joined
)
, segment_table AS ( 
SELECT *
, CASE WHEN percentrank <= 0.1 THEN 'Vip'
 WHEN percentrank <= 0.3 THEN 'Gold'
 WHEN percentrank <= 0.6 THEN 'Silver'
 ELSE 'Bronze' 
 END AS segment
FROM percentrank_table
)
, segment_value_table AS (
SELECT segment
, COUNT(customer_id) AS total_customers
, SUM(total_orders) AS total_segment_order
,SUM(CAST (total_revenue AS BIGINT)) AS total_segment_revenue
, AVG(CAST(total_revenue AS BIGINT)) AS avg_revenue_per_customer
FROM segment_table
GROUP BY segment
)
SELECT *
,ROUND(CAST (total_segment_revenue AS FLOAT)/ SUM(total_segment_revenue) OVER ()*100,2) AS revenue_share_pct
FROM segment_value_table
;
/*
CUSTOMER SEGMENTATION INSIGHTS

1. Customer revenue is highly concentrated among a small group of high-value customers.

2. The VIP segment represents only 10% of customers but contributes over 90% of total revenue.

3. Gold and Silver customers generate moderate revenue and provide opportunities for customer value growth.

4. Bronze customers account for the largest share of the customer base but contribute only a small portion of total revenue.

5. The business is heavily dependent on VIP customers, making retention and loyalty initiatives critical.

6. Customer segmentation can support targeted marketing, personalized promotions, and customer retention strategies.
*/