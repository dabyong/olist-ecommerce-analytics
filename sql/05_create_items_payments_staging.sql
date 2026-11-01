
USE olist_ecommerce;

-- Order Items
CREATE TABLE IF NOT EXISTS stg_order_items (
    order_id VARCHAR(32),
    order_item_id INT,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date DATETIME,
    price DECIMAL(12,2),
    freight_value DECIMAL(12,2)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;

-- Order Payments
CREATE TABLE IF NOT EXISTS stg_order_payments (
    order_id VARCHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(12,2)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;

-- Verify both tables
SHOW TABLES LIKE 'stg_order_items';
SHOW TABLES LIKE 'stg_order_payments';
