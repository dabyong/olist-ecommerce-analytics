
USE olist_ecommerce;

-- =========================================
-- STEP 26: FINANCIAL RECONCILIATION
-- =========================================

-- Aggregate order items and payments
-- separately to prevent duplicate revenue
-- when joining one-to-many tables.

CREATE OR REPLACE VIEW
vw_order_financial_reconciliation AS

SELECT
    o.order_id,
    o.order_status,

    COALESCE(i.item_value, 0) AS item_value,
    COALESCE(i.freight_value, 0) AS freight_value,
    COALESCE(p.payment_value, 0) AS payment_value,

    ROUND(
        COALESCE(p.payment_value, 0)
        - COALESCE(i.item_value, 0)
        - COALESCE(i.freight_value, 0),
        2
    ) AS payment_difference,

    CASE
        WHEN i.order_id IS NULL THEN 1
        ELSE 0
    END AS missing_items,

    CASE
        WHEN p.order_id IS NULL THEN 1
        ELSE 0
    END AS missing_payments

FROM fact_orders o

LEFT JOIN (
    SELECT
        order_id,
        SUM(price) AS item_value,
        SUM(freight_value) AS freight_value
    FROM fact_order_items
    GROUP BY order_id
) i ON o.order_id = i.order_id

LEFT JOIN (
    SELECT
        order_id,
        SUM(payment_value) AS payment_value
    FROM fact_payments
    GROUP BY order_id
) p ON o.order_id = p.order_id;


-- =========================================
-- QUERY 1: OVERALL RECONCILIATION
-- =========================================

SELECT
    COUNT(*) AS total_orders,

    ROUND(SUM(item_value), 2)
        AS total_item_value,

    ROUND(SUM(freight_value), 2)
        AS total_freight,

    ROUND(SUM(payment_value), 2)
        AS total_payments,

    ROUND(SUM(payment_difference), 2)
        AS total_difference,

    SUM(missing_items) AS orders_without_items,
    SUM(missing_payments) AS orders_without_payments,

    SUM(
        CASE
            WHEN ABS(payment_difference) > 0.01
            THEN 1 ELSE 0
        END
    ) AS orders_with_differences

FROM vw_order_financial_reconciliation;


-- =========================================
-- QUERY 2: DIFFERENCES BY ORDER STATUS
-- =========================================

SELECT
    order_status,
    COUNT(*) AS total_orders,

    ROUND(SUM(item_value), 2)
        AS item_value,

    ROUND(SUM(freight_value), 2)
        AS freight_value,

    ROUND(SUM(payment_value), 2)
        AS payment_value,

    ROUND(SUM(payment_difference), 2)
        AS difference

FROM vw_order_financial_reconciliation

GROUP BY order_status
ORDER BY total_orders DESC;


-- =========================================
-- QUERY 3: LARGEST INDIVIDUAL DIFFERENCES
-- =========================================

SELECT
    order_id,
    order_status,
    item_value,
    freight_value,
    payment_value,
    payment_difference

FROM vw_order_financial_reconciliation

WHERE ABS(payment_difference) > 0.01

ORDER BY ABS(payment_difference) DESC

LIMIT 15;
