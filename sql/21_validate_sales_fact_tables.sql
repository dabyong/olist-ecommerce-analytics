
USE olist_ecommerce;

-- ORDER ITEMS VALIDATION

SELECT
    COUNT(*) AS total_items,
    COUNT(DISTINCT order_id) AS orders_with_items,
    ROUND(SUM(price), 2) AS total_item_value,
    ROUND(SUM(freight_value), 2) AS total_freight
FROM fact_order_items;


-- PAYMENTS VALIDATION

SELECT
    COUNT(*) AS total_payments,
    COUNT(DISTINCT order_id) AS orders_with_payments,
    ROUND(SUM(payment_value), 2) AS total_payments_value
FROM fact_payments;
