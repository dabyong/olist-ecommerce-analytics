
USE olist_ecommerce;

-- ============================================
-- PRODUCT & SELLER DASHBOARD DATA
-- One row per delivered order item
-- ============================================

CREATE OR REPLACE VIEW
vw_dashboard_product_seller AS

SELECT
    v.order_id,
    v.order_item_id,
    v.order_purchase_timestamp,

    YEAR(v.order_purchase_timestamp)
        AS purchase_year,

    DATE_FORMAT(
        v.order_purchase_timestamp, '%Y-%m'
    ) AS purchase_month,

    v.product_id,
    v.category AS product_category,

    v.seller_id,
    s.seller_city,
    s.seller_state,

    v.price AS merchandise_value,
    v.freight_value

FROM vw_delivered_item_sales v

JOIN dim_sellers s
    ON v.seller_id = s.seller_id;


-- ============================================
-- VALIDATE THE VIEW
-- ============================================

SELECT
    COUNT(*) AS total_items,

    COUNT(DISTINCT order_id)
        AS delivered_orders,

    COUNT(DISTINCT seller_id)
        AS active_sellers,

    ROUND(SUM(merchandise_value), 2)
        AS merchandise_value

FROM vw_dashboard_product_seller;
