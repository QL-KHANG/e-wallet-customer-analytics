--Task 6 (Retention/Cohort Analysis)
--.1 - Monthly Active Customers
SELECT DATEFROMPARTS ( YEAR(transaction_date), MONTH(transaction_date), 1) AS activity_month
, COUNT(DISTINCT customer_id) AS active_customers
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1
GROUP BY  DATEFROMPARTS ( YEAR(transaction_date), MONTH(transaction_date), 1)
ORDER BY  activity_month ASC
;

--2 - New vs Returning Customers
WITH cus_first_month AS (
SELECT customer_id
, DATEFROMPARTS ( YEAR(transaction_date), MONTH(transaction_date), 1) AS activity_month
, MIN (DATEFROMPARTS ( YEAR(transaction_date) ,MONTH(transaction_date) ,1)) OVER (PARTITION BY customer_id) AS first_month
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1
)
SELECT activity_month
, COUNT(DISTINCT CASE WHEN activity_month = first_month THEN customer_id END ) AS new_customers
, COUNT(DISTINCT CASE WHEN activity_month > first_month THEN customer_id END) AS return_customers
FROM cus_first_month
GROUP BY activity_month
ORDER BY activity_month
;

--3 - Cohort Retention Table
WITH first_purchase AS (
SELECT customer_id, transaction_date
, MIN(transaction_date) OVER (PARTITION BY customer_id) AS first_purchase_date
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1
)
, first_month_table AS (
    SELECT *,
  DATEFROMPARTS( YEAR(first_purchase_date), MONTH(first_purchase_date),1 ) AS first_month FROM first_purchase
  )
, month_n_table AS (
SELECT *
, month_n =DATEDIFF(MONTH, first_purchase_date, transaction_date)
FROM first_month_table
)
SELECT first_month, month_n
, COUNT(DISTINCT customer_id) AS retained_customers
FROM month_n_table
GROUP BY first_month, month_n
ORDER BY first_month, month_n ASC
;

--4.- Cohort Retention Rate (%)
WITH first_purchase AS (
SELECT customer_id, transaction_date
, MIN(transaction_date) OVER (PARTITION BY customer_id) AS first_purchase_date
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1
)
, first_month_table AS (
    SELECT *,
  DATEFROMPARTS( YEAR(first_purchase_date), MONTH(first_purchase_date),1 ) AS first_month FROM first_purchase
  )
, month_n_table AS (
    SELECT *
, DATEDIFF(MONTH, first_purchase_date, transaction_date ) AS month_n 
FROM first_month_table
)
, retained_cus AS (
SELECT first_month, month_n
, COUNT(DISTINCT customer_id) AS retained_customers
FROM month_n_table
GROUP BY first_month, month_n
)
,retention_table AS (
SELECT *
,FIRST_VALUE(retained_customers) OVER(PARTITION BY first_month ORDER BY month_n ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS original_customers
FROM retained_cus
)
SELECT *
, ROUND ( CAST (retained_customers AS FLOAT)/NULLIF(original_customers,0)*100,2) AS retention_rate_pct
FROM retention_table
ORDER BY first_month, month_n

/*
TASK 6 - CUSTOMER RETENTION ANALYSIS

1. Monthly active customers remained relatively stable throughout the 2017–2018 period, reaching a peak of 3,654 customers in August 2018.

2. Returning customers consistently outnumbered new customers after each cohort’s acquisition month, indicating strong repeat purchase behavior.

3. The largest customer drop-off occurred immediately after the first purchase month, with retention declining from 100% to 57.64%.

4. Retention rates stabilized at around 50% in later periods, suggesting the presence of a loyal and engaged customer base.

5. Existing customers contributed significantly to overall platform activity, highlighting customer retention as an important driver of long-term growth.

6. Overall cohort performance indicates healthy customer engagement and sustainable retention across multiple acquisition cohorts.