
USE olist_ecommerce;

SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_id) AS customers_linked,
    SUM(has_quality_issue) AS flagged_orders,
    SUM(eligible_delivery_kpi) AS valid_delivery_orders,
    SUM(eligible_shipping_timeline) AS valid_shipping_orders
FROM fact_orders;

-- Confirm no broken customer relationships
SELECT COUNT(*) AS orphan_orders
FROM fact_orders o
LEFT JOIN dim_customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
