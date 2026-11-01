
USE olist_ecommerce;

-- =========================================
-- STEP 29: PRODUCT & CATEGORY ANALYTICS
-- =========================================

CREATE OR REPLACE VIEW vw_delivered_item_sales AS

SELECT
    i.order_id,
    i.order_item_id,
    o.order_purchase_timestamp,
    i.product_id,
    p.category_name_english AS category,
    i.seller_id,
    i.price,
    i.freight_value

FROM fact_order_items i

JOIN fact_orders o
    ON i.order_id = o.order_id

JOIN dim_products p
    ON i.product_id = p.product_id

WHERE o.order_status = 'delivered';


-- =========================================
-- QUERY 1: VALIDATE MERCHANDISE TOTAL
-- =========================================

SELECT
    COUNT(*) AS delivered_item_rows,
    COUNT(DISTINCT order_id) AS orders_with_items,
    ROUND(SUM(price), 2) AS merchandise_value
FROM vw_delivered_item_sales;


-- =========================================
-- QUERY 2: TOP 15 PRODUCT CATEGORIES
-- =========================================

WITH category_sales AS (
    SELECT
        category,
        COUNT(*) AS items_sold,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(price) AS merchandise_value,
        SUM(freight_value) AS freight_value
    FROM vw_delivered_item_sales
    GROUP BY category
)

SELECT
    category,
    items_sold,
    total_orders,
    ROUND(merchandise_value, 2)
        AS merchandise_value,
    ROUND(freight_value, 2)
        AS freight_value,
    ROUND(
        merchandise_value * 100 /
        NULLIF(SUM(merchandise_value) OVER (), 0),
        2
    ) AS sales_share_pct

FROM category_sales
ORDER BY merchandise_value DESC
LIMIT 15;


-- =========================================
-- QUERY 3: TOP 10 INDIVIDUAL PRODUCTS
-- =========================================

SELECT
    product_id,
    category,
    COUNT(*) AS units_sold,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price), 2) AS merchandise_value,
    ROUND(AVG(price), 2) AS avg_selling_price

FROM vw_delivered_item_sales

GROUP BY product_id, category

ORDER BY merchandise_value DESC
LIMIT 10;
