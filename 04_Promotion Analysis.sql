--Task 4 - Promotion Analysis
--1: Promotion Adoption
SELECT COUNT(order_id) AS total_promotion_orders
, ROUND(
CAST(COUNT(order_id) AS FLOAT) /
NULLIF(
    (
    SELECT COUNT(order_id)
    FROM (
        SELECT * FROM payment_history_17
        UNION ALL
        SELECT * FROM payment_history_18
    ) his
    WHERE message_id = 1
    ),0
)*100,2) AS promotion_adoption_pct
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1 AND promotion_id <> '0'
;

--2: Total Discount Cost
SELECT SUM(CAST(discount_price AS BIGINT)) AS total_discount
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1 AND promotion_id <> '0'
; 

--3: Top Promotion by Revenue
SELECT promotion_id
,COUNT(order_id) AS total_promotion_orders
, SUM(CAST(discount_price AS BIGINT)) AS total_discount
, SUM(CAST(final_price AS BIGINT)) AS total_revenue
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1 AND promotion_id <> '0'
GROUP BY promotion_id
ORDER BY total_revenue DESC
;

--4:Promotion Efficiency
SELECT promotion_id
, COUNT(order_id) AS total_promotion_orders
, SUM(CAST(discount_price AS BIGINT)) AS total_discount
, SUM(CAST(final_price AS BIGINT)) AS total_revenue
, ROUND( SUM(CAST(final_price AS FLOAT))/NULLIF(SUM(CAST(discount_price AS FLOAT)),0),2) AS revenue_per_discount
FROM (SELECT * FROM payment_history_17 UNION ALL SELECT * FROM payment_history_18) AS his 
WHERE message_id = 1 AND promotion_id <> '0' AND discount_price > 0
GROUP BY promotion_id
ORDER BY revenue_per_discount DESC

/*
PROMOTION ANALYSIS INSIGHTS

1. Only 8.75% of successful transactions used promotions.

2. The company invested over 474 million in promotional discounts.

3. Promotion performance is uneven, with a small number of campaigns driving most promotional revenue.

4. Revenue alone is insufficient to evaluate promotion effectiveness.

5. Revenue-per-discount analysis highlights which promotions deliver the highest return on promotional spending.

6. High-efficiency promotions may provide better returns on promotional spending.
*/