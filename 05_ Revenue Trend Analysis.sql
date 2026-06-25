--Task 5 - Revenue Trend Analysis
--.1 Revenue by Month
SELECT MONTH(transaction_date) AS [month]
,YEAR(transaction_date) AS [year]
, SUM(CAST(final_price AS BIGINT)) AS total_revenue
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1
GROUP BY YEAR(transaction_date), MONTH(transaction_date)
ORDER BY [year], [month] ASC
;
--.2 Month-over-Month Growth
WITH table_month AS (
SELECT MONTH(transaction_date) AS [month]
,YEAR(transaction_date) AS [year]
, SUM(CAST(final_price AS BIGINT)) AS total_revenue
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1
GROUP BY YEAR(transaction_date), MONTH(transaction_date)
)
, lag_table AS (
SELECT *
, LAG(total_revenue,1) OVER (ORDER BY [year], [month] ASC) AS pre_month_revenue
, total_revenue - LAG(total_revenue,1) OVER (ORDER BY [year], [month] ASC) AS revenue_change
FROM table_month
)
SELECT *
,ROUND( CAST (revenue_change AS FLOAT)/NULLIF(pre_month_revenue,0)*100 ,2 ) AS MoM_growth_pct
FROM lag_table
;
--.3 Running Revenue 
WITH table_month AS (
SELECT MONTH(transaction_date) AS [month]
,YEAR(transaction_date) AS [year]
, SUM(CAST(final_price AS BIGINT)) AS total_revenue
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1
GROUP BY YEAR(transaction_date), MONTH(transaction_date)
)
SELECT *
, accumulating_revenue = SUM(total_revenue) OVER (ORDER BY [year], [month] ASC 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
FROM table_month

/*
TASK 5 - REVENUE TREND ANALYSIS

1. Monthly revenue fluctuated throughout 2017-2018, with February 2017 recording the lowest revenue level.

2. Revenue was generally higher during the second half of the year, which may indicate seasonal demand patterns.

3. The largest month-over-month revenue increases occurred in August, October, and December, indicating periods of accelerated transaction growth.

4. December 2018 generated the highest monthly revenue, highlighting strong year-end customer spending activity.

5. Cumulative revenue grew consistently over time, reflecting sustained business expansion despite short-term volatility.

6. Overall revenue trends indicate positive business growth over the 2017-2018 period.
*/