
USE olist_ecommerce;

-- ============================================
-- STEP 33: DASHBOARD-READY ORDER SUMMARY
-- Grain: One row per order
-- ============================================

CREATE OR REPLACE VIEW vw_dashboard_order_summary AS

SELECT
    o.order_id,

    -- Purchase information
    o.order_purchase_timestamp,

    DATE_FORMAT(
        o.order_purchase_timestamp, '%Y-%m'
    ) AS purchase_month,

    YEAR(o.order_purchase_timestamp)
        AS purchase_year,

    o.order_status,

    -- Customer information
    c.customer_unique_id,
    c.customer_state,

    -- Financial information
    f.item_value,
    f.freight_value,
    f.payment_value,

    CASE
        WHEN o.order_status = 'delivered'
        THEN f.item_value
        ELSE 0
    END AS delivered_merchandise_value,

    -- Data quality
    o.has_quality_issue,
    o.eligible_delivery_kpi,

    -- Delivery performance
    d.delivery_days,
    d.days_vs_estimate,
    d.delivery_status,

    CASE
        WHEN d.delivery_status = 'Late' THEN 1
        WHEN d.order_id IS NOT NULL THEN 0
        ELSE NULL
    END AS late_delivery_flag,

    -- Customer satisfaction
    r.review_count,
    r.avg_review_score

FROM fact_orders o

JOIN dim_customers c
    ON o.customer_id = c.customer_id

JOIN vw_order_financial_reconciliation f
    ON o.order_id = f.order_id

LEFT JOIN vw_delivery_satisfaction d
    ON o.order_id = d.order_id

LEFT JOIN vw_order_review_summary r
    ON o.order_id = r.order_id;


-- ============================================
-- QUERY 1: VERIFY FINANCIAL TOTALS
-- ============================================

SELECT
    COUNT(*) AS total_orders,

    COUNT(DISTINCT order_id)
        AS unique_orders,

    SUM(order_status = 'delivered')
        AS delivered_orders,

    ROUND(
        SUM(delivered_merchandise_value), 2
    ) AS delivered_merchandise_value

FROM vw_dashboard_order_summary;


-- ============================================
-- QUERY 2: VERIFY DELIVERY KPIs
-- ============================================

SELECT
    COUNT(delivery_days)
        AS eligible_delivery_orders,

    SUM(late_delivery_flag)
        AS late_orders,

    ROUND(AVG(delivery_days), 2)
        AS avg_delivery_days,

    ROUND(
        100.0 * SUM(late_delivery_flag)
        / NULLIF(
            COUNT(late_delivery_flag), 0
        ), 2
    ) AS late_delivery_pct

FROM vw_dashboard_order_summary;


-- ============================================
-- QUERY 3: VERIFY CUSTOMER RATINGS
-- ============================================

SELECT
    COUNT(
        CASE
            WHEN delivery_status IS NOT NULL
             AND avg_review_score IS NOT NULL
            THEN 1
        END
    ) AS reviewed_delivery_orders,

    ROUND(AVG(
        CASE
            WHEN delivery_status = 'Late'
            THEN avg_review_score
        END
    ), 2) AS late_avg_rating,

    ROUND(AVG(
        CASE
            WHEN delivery_status = 'On Time / Early'
            THEN avg_review_score
        END
    ), 2) AS ontime_avg_rating

FROM vw_dashboard_order_summary;


-- ============================================
-- QUERY 4: VERIFY NO DUPLICATED ORDERS
-- ============================================

SELECT COUNT(*) AS duplicate_order_ids
FROM (
    SELECT order_id
    FROM vw_dashboard_order_summary
    GROUP BY order_id
    HAVING COUNT(*) > 1
) duplicates;
