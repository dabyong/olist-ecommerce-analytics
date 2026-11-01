
USE olist_ecommerce;

-- Order Items Financial Summary
SELECT
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT order_id) AS orders_with_items,
    ROUND(SUM(price), 2) AS total_item_value,
    ROUND(SUM(freight_value), 2) AS total_freight_value
FROM stg_order_items;

-- Payments Financial Summary
SELECT
    COUNT(*) AS total_payment_records,
    COUNT(DISTINCT order_id) AS orders_with_payments,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM stg_order_payments;

-- Payment is Null
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp
FROM stg_orders o
LEFT JOIN stg_order_payments p
    ON o.order_id = p.order_id
WHERE p.order_id IS NULL;
