--Task 8 - Dynamic Pivot Revenue Report.
DECLARE @column_list NVARCHAR(MAX)
DECLARE @query NVARCHAR (MAX)

SELECT @column_list =  STRING_AGG(QUOTENAME(CONVERT(VARCHAR(10), activity_month, 23)),', ')WITHIN GROUP(ORDER BY activity_month ASC)
FROM (
SELECT DISTINCT DATEFROMPARTS( YEAR(transaction_date), MONTH(transaction_date), 1 ) AS activity_month
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM  payment_history_18) AS his 
) AS tmp
-- PRINT(@column_list)

SET @query = '
WITH table_joined AS (
SELECT 
DATEFROMPARTS( YEAR(transaction_date), MONTH(transaction_date), 1 ) AS activity_month, category
, SUM(CAST(final_price AS BIGINT)) AS revenue
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM  payment_history_18) AS his 
LEFT JOIN product AS pro 
ON his.product_id = pro.product_number
WHERE message_id  = 1
GROUP BY DATEFROMPARTS( YEAR(transaction_date), MONTH(transaction_date), 1 ), category
)
SELECT  category
, '+@column_list+'
FROM (
    SELECT  activity_month, category, CAST(revenue AS BIGINT) AS revenue
    FROM table_joined
) AS source_table
PIVOT 
(
    SUM(revenue) FOR activity_month IN ('+@column_list+')
) AS pivot_logic
ORDER BY category ASC'

EXEC sp_executesql @query

/*--TASK 8 - DYNAMIC PIVOT REVENUE REPORT
INSIGHTS

1. Revenue was generated across a broad range of product categories, indicating a diversified revenue structure.

2. Billing, Telco, Marketplace, and Not Payment were among the highest revenue-generating categories across multiple months.

3. Revenue patterns varied across categories, with some categories demonstrating stronger performance during later periods of the year.

4. The dynamic pivot report enables flexible month-by-month revenue comparison without requiring manual query updates when new periods are added.

5. This reporting structure can be easily extended to support future business intelligence dashboards and automated reporting processes.
