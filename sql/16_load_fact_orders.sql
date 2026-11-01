
USE olist_ecommerce;

INSERT INTO fact_orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    quality_issues,
    has_quality_issue,
    eligible_delivery_kpi,
    eligible_shipping_timeline
)
SELECT
    s.order_id,
    s.customer_id,
    s.order_status,
    s.order_purchase_timestamp,
    s.order_approved_at,
    s.order_delivered_carrier_date,
    s.order_delivered_customer_date,
    s.order_estimated_delivery_date,
    s.quality_issues,
    s.has_quality_issue,
    s.eligible_delivery_kpi,
    s.eligible_shipping_timeline
FROM stg_orders s
WHERE NOT EXISTS (
    SELECT 1
    FROM fact_orders f
    WHERE f.order_id = s.order_id
);
