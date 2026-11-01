USE olist_ecommerce;

-- =========================================
-- STEP 30: SELLER PERFORMANCE ANALYSIS
-- =========================================

CREATE OR REPLACE VIEW vw_seller_performance AS

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,

    COUNT(*) AS items_sold,

    COUNT(DISTINCT v.order_id)
        AS orders_fulfilled,

    ROUND(SUM(v.price), 2)
        AS merchandise_value,

    ROUND(SUM(v.freight_value), 2)
        AS freight_value,

    ROUND(AVG(v.price), 2)
        AS avg_item_price

FROM vw_delivered_item_sales v

JOIN dim_sellers s
    ON v.seller_id = s.seller_id

GROUP BY
    s.seller_id,
    s.seller_city,
    s.seller_state;


-- =========================================
-- QUERY 1: VALIDATE SELLER TOTALS
-- =========================================

SELECT
    COUNT(*) AS active_sellers,

    SUM(items_sold) AS total_items,

    ROUND(SUM(merchandise_value), 2)
        AS total_merchandise_value

FROM vw_seller_performance;


-- =========================================
-- QUERY 2: TOP 10 SELLERS
-- =========================================

SELECT
    seller_id,
    seller_state,
    items_sold,
    orders_fulfilled,
    merchandise_value,
    avg_item_price,

    ROUND(
        merchandise_value * 100 /
        NULLIF(
            SUM(merchandise_value) OVER (), 0
        ), 2
    ) AS sales_share_pct

FROM vw_seller_performance

ORDER BY merchandise_value DESC
LIMIT 10;


-- =========================================
-- QUERY 3: SELLER PERFORMANCE BY STATE
-- =========================================

SELECT
    seller_state,

    COUNT(*) AS active_sellers,

    SUM(items_sold) AS items_sold,

    ROUND(SUM(merchandise_value), 2)
        AS merchandise_value

FROM vw_seller_performance

GROUP BY seller_state
ORDER BY merchandise_value DESC;
