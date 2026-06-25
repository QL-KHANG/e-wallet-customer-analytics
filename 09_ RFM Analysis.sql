--Task 9 - RFM Analysis
--1. Customer RFM Metrics
WITH table_rfm AS (
SELECT customer_id
, RECENCY = DATEDIFF(day, MAX(transaction_date), '2018-12-31') 
, FREQUENCY = COUNT(order_id) 
, MONETARY = SUM(CAST(final_price AS BIGINT))
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his
WHERE message_id = 1
GROUP BY customer_id
)

--2 - RFM Scoring
,rank_table AS (
SELECT *
, PERCENT_RANK() OVER(ORDER BY RECENCY ASC) AS r_rank
, PERCENT_RANK() OVER(ORDER BY FREQUENCY DESC) AS f_rank
, PERCENT_RANK() OVER(ORDER BY MONETARY DESC) AS m_rank
FROM table_rfm
)

--3.RFM Tier Assignment
,tier_table AS (
SELECT *
, CASE WHEN r_rank <= 0.25 THEN '1'
 WHEN r_rank <= 0.5 THEN '2'
 WHEN r_rank <= 0.75 THEN '3'
 ELSE '4' END AS r_tier
 , CASE WHEN f_rank <= 0.25 THEN '1'
 WHEN f_rank <= 0.5 THEN '2'
 WHEN f_rank <= 0.75 THEN '3'
 ELSE '4' END AS f_tier
 , CASE WHEN m_rank <= 0.25 THEN '1'
 WHEN m_rank <= 0.5 THEN '2'
 WHEN m_rank <= 0.75 THEN '3'
 ELSE '4' END AS m_tier
FROM rank_table
)
, score_table AS (
SELECT *
 ,CONCAT(r_tier, f_tier, m_tier) AS rfm_score
FROM tier_table
)
,segment_table AS (
-- Customer segments are defined using custom business rules
SELECT *
, CASE WHEN rfm_score = '111' THEN 'Champions'
 WHEN rfm_score LIKE '[1-2][1-2][1-4]' THEN 'Loyal Customers'
 WHEN rfm_score LIKE '[1-2][3-4][1-4]' THEN 'Potential Customers'
 WHEN rfm_score LIKE '[3-4][1-2][1-4]' THEN 'At Risk'
ELSE 'Lost Customers'
 END AS segment
FROM score_table
)
SELECT segment
, COUNT(customer_id) AS customers
, SUM(FREQUENCY) AS total_orders
, SUM(MONETARY) AS total_revenue
, AVG(MONETARY) AS avg_revenue_per_customer
, ROUND (CAST(SUM(MONETARY) AS FLOAT)/SUM(SUM(MONETARY)) OVER ()*100,2) AS revenue_share_pct
FROM segment_table
GROUP BY segment
ORDER BY total_revenue DESC

/*
TASK 9 - RFM ANALYSIS 
INSIGHTS

1. Champions account for approximately 11% of customers while generating 65.38% of total revenue, making them the most valuable customer segment.

2. Loyal Customers contribute 22.72% of total revenue and provide a strong foundation for recurring business performance.

3. At Risk Customers still generate 10.81% of revenue, representing a meaningful opportunity for retention and reactivation initiatives.

4. Lost Customers form the largest customer segment (3,650 customers) but contribute only 0.76% of total revenue, indicating very low current business value.

5. Champions and Loyal Customers together contribute 88.10% of total revenue, showing that revenue is highly concentrated among highly engaged customers.

6. The distribution of customer value is highly uneven, suggesting that retention strategies focused on high-value segments can have a significant impact on overall business performance.