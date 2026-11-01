
USE olist_ecommerce;

-- =============================================
-- STEP 32: DELIVERY & SATISFACTION ANALYSIS
-- =============================================

-- Check eligible orders and missing estimates
SELECT
    COUNT(*) AS eligible_orders,
    SUM(order_estimated_delivery_date IS NULL)
        AS missing_estimated_dates
FROM fact_orders
WHERE order_status = 'delivered'
  AND eligible_delivery_kpi = 1;


-- =============================================
-- 1. AGGREGATE REVIEWS TO ONE ROW PER ORDER
-- =============================================

CREATE OR REPLACE VIEW vw_order_review_summary AS
SELECT
    order_id,
    COUNT(*) AS review_count,
    AVG(review_score) AS avg_review_score
FROM fact_reviews
GROUP BY order_id;


-- =============================================
-- 2. DELIVERY PERFORMANCE VIEW
-- =============================================

CREATE OR REPLACE VIEW vw_delivery_satisfaction AS
SELECT
    o.order_id,

    DATE(o.order_purchase_timestamp)
        AS purchase_date,

    DATE(o.order_estimated_delivery_date)
        AS estimated_delivery_date,

    DATE(o.order_delivered_customer_date)
        AS actual_delivery_date,

    ROUND(
        TIMESTAMPDIFF(
            SECOND,
            o.order_purchase_timestamp,
            o.order_delivered_customer_date
        ) / 86400.0, 2
    ) AS delivery_days,

    DATEDIFF(
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date
    ) AS days_vs_estimate,

    CASE
        WHEN DATE(o.order_delivered_customer_date)
             > DATE(o.order_estimated_delivery_date)
        THEN 'Late'
        ELSE 'On Time / Early'
    END AS delivery_status,

    r.review_count,
    r.avg_review_score

FROM fact_orders o

LEFT JOIN vw_order_review_summary r
    ON o.order_id = r.order_id

WHERE o.order_status = 'delivered'
  AND o.eligible_delivery_kpi = 1
  AND o.order_estimated_delivery_date IS NOT NULL;


-- =============================================
-- QUERY 1: OVERALL DELIVERY PERFORMANCE
-- =============================================

SELECT
    COUNT(*) AS orders_analyzed,

    SUM(delivery_status = 'Late')
        AS late_orders,

    ROUND(
        100.0 * SUM(delivery_status = 'Late')
        / NULLIF(COUNT(*), 0), 2
    ) AS late_delivery_pct,

    ROUND(AVG(delivery_days), 2)
        AS avg_delivery_days,

    COUNT(avg_review_score)
        AS orders_with_reviews

FROM vw_delivery_satisfaction;


-- =============================================
-- QUERY 2: REVIEWS BY DELIVERY STATUS
-- =============================================

SELECT
    delivery_status,

    COUNT(*) AS total_orders,

    COUNT(avg_review_score)
        AS reviewed_orders,

    ROUND(AVG(avg_review_score), 2)
        AS avg_review_score

FROM vw_delivery_satisfaction

GROUP BY delivery_status;


-- =============================================
-- QUERY 3: REVIEWS BY DELAY CATEGORY
-- =============================================

SELECT
    CASE
        WHEN days_vs_estimate <= -7
            THEN '7+ Days Early'
        WHEN days_vs_estimate BETWEEN -6 AND -1
            THEN '1-6 Days Early'
        WHEN days_vs_estimate = 0
            THEN 'On Estimated Date'
        WHEN days_vs_estimate BETWEEN 1 AND 3
            THEN '1-3 Days Late'
        WHEN days_vs_estimate BETWEEN 4 AND 7
            THEN '4-7 Days Late'
        ELSE '8+ Days Late'
    END AS delay_category,

    COUNT(*) AS total_orders,

    COUNT(avg_review_score)
        AS reviewed_orders,

    ROUND(AVG(avg_review_score), 2)
        AS avg_review_score

FROM vw_delivery_satisfaction

GROUP BY delay_category

ORDER BY FIELD(
    delay_category,
    '7+ Days Early',
    '1-6 Days Early',
    'On Estimated Date',
    '1-3 Days Late',
    '4-7 Days Late',
    '8+ Days Late'
);
