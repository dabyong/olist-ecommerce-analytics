
USE olist_ecommerce;

-- =========================================
-- STEP 31: CUSTOMER BEHAVIOR ANALYSIS
-- =========================================

-- One row per delivered order
CREATE OR REPLACE VIEW vw_customer_order_history AS

SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_state,
    o.order_purchase_timestamp,
    s.item_value AS merchandise_value

FROM vw_delivered_order_sales s

JOIN fact_orders o
    ON s.order_id = o.order_id

JOIN dim_customers c
    ON o.customer_id = c.customer_id;


-- =========================================
-- CUSTOMER PURCHASE SUMMARY
-- =========================================

CREATE OR REPLACE VIEW vw_customer_purchase_summary AS

SELECT
    customer_unique_id,

    COUNT(*) AS delivered_orders,

    MIN(order_purchase_timestamp)
        AS first_purchase,

    MAX(order_purchase_timestamp)
        AS last_purchase,

    ROUND(SUM(merchandise_value), 2)
        AS merchandise_value

FROM vw_customer_order_history

GROUP BY customer_unique_id;


-- =========================================
-- QUERY 1: VALIDATE CUSTOMER SALES
-- =========================================

SELECT
    COUNT(*) AS total_delivered_orders,

    COUNT(DISTINCT customer_unique_id)
        AS unique_buyers,

    ROUND(SUM(merchandise_value), 2)
        AS total_merchandise_value

FROM vw_customer_order_history;


-- =========================================
-- QUERY 2: REPEAT PURCHASE METRICS
-- =========================================

SELECT
    COUNT(*) AS total_buyers,

    SUM(delivered_orders >= 2)
        AS repeat_buyers,

    SUM(delivered_orders = 1)
        AS one_time_buyers,

    ROUND(
        100.0 * SUM(delivered_orders >= 2)
        / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_buyer_pct,

    ROUND(AVG(delivered_orders), 2)
        AS avg_orders_per_buyer

FROM vw_customer_purchase_summary;


-- =========================================
-- QUERY 3: SALES BY CUSTOMER SEGMENT
-- =========================================

WITH customer_segments AS (
    SELECT
        CASE
            WHEN delivered_orders = 1
            THEN 'One-time Buyer'
            ELSE 'Repeat Buyer'
        END AS customer_segment,

        COUNT(*) AS total_buyers,

        SUM(delivered_orders) AS total_orders,

        SUM(merchandise_value)
            AS merchandise_value

    FROM vw_customer_purchase_summary

    GROUP BY
        CASE
            WHEN delivered_orders = 1
            THEN 'One-time Buyer'
            ELSE 'Repeat Buyer'
        END
)

SELECT
    customer_segment,
    total_buyers,
    total_orders,

    ROUND(merchandise_value, 2)
        AS merchandise_value,

    ROUND(
        merchandise_value * 100 /
        NULLIF(
            SUM(merchandise_value) OVER (), 0
        ),
        2
    ) AS sales_share_pct

FROM customer_segments;


-- =========================================
-- QUERY 4: TOP 10 REPEAT BUYERS
-- =========================================

SELECT
    customer_unique_id,
    delivered_orders,
    first_purchase,
    last_purchase,
    merchandise_value

FROM vw_customer_purchase_summary

WHERE delivered_orders >= 2

ORDER BY
    delivered_orders DESC,
    merchandise_value DESC

LIMIT 10;
