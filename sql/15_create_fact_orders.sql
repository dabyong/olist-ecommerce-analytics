
USE olist_ecommerce;

CREATE TABLE IF NOT EXISTS fact_orders (

    -- Primary key
    order_id VARCHAR(32) NOT NULL,

    -- Foreign key
    customer_id VARCHAR(32) NOT NULL,

    -- Order information
    order_status VARCHAR(32) NOT NULL,
    order_purchase_timestamp DATETIME NOT NULL,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,

    -- Data quality information
    quality_issues TEXT,
    has_quality_issue TINYINT NOT NULL DEFAULT 0,
    eligible_delivery_kpi TINYINT NOT NULL DEFAULT 0,
    eligible_shipping_timeline TINYINT NOT NULL DEFAULT 0,

    -- Primary key constraint
    PRIMARY KEY (order_id),

    -- Indexes
    INDEX idx_customer_id (customer_id),
    INDEX idx_purchase_date (order_purchase_timestamp),
    INDEX idx_order_status (order_status),

    -- Foreign key constraint
    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES dim_customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
