
USE olist_ecommerce;

-- Check whether any orders reference
-- customers missing from our dimension table

SELECT COUNT(*) AS orphan_orders
FROM stg_orders o
LEFT JOIN dim_customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Check the order IDs
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders,
    SUM(order_id IS NULL) AS null_order_ids
FROM stg_orders;
