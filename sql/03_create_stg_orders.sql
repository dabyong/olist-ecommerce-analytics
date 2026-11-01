
USE olist_ecommerce;

CREATE TABLE IF NOT EXISTS stg_orders (
    order_id VARCHAR(32),
    customer_id VARCHAR(32),
    order_status VARCHAR(32),

    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,

    quality_issues TEXT,
    has_quality_issue TINYINT,
    eligible_delivery_kpi TINYINT,
    eligible_shipping_timeline TINYINT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

SHOW TABLES LIKE 'stg_orders';
