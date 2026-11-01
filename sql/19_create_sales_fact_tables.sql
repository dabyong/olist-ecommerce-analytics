
USE olist_ecommerce;

-- ===================================
-- ORDER ITEMS FACT TABLE
-- ===================================

CREATE TABLE IF NOT EXISTS fact_order_items (
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    seller_id VARCHAR(32) NOT NULL,
    shipping_limit_date DATETIME,
    price DECIMAL(12,2) NOT NULL,
    freight_value DECIMAL(12,2) NOT NULL,

    PRIMARY KEY (order_id, order_item_id),

    INDEX idx_item_product (product_id),
    INDEX idx_item_seller (seller_id),

    CONSTRAINT fk_item_orders
        FOREIGN KEY (order_id)
        REFERENCES fact_orders(order_id),

    CONSTRAINT fk_item_products
        FOREIGN KEY (product_id)
        REFERENCES dim_products(product_id),

    CONSTRAINT fk_item_sellers
        FOREIGN KEY (seller_id)
        REFERENCES dim_sellers(seller_id)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- ===================================
-- PAYMENTS FACT TABLE
-- ===================================

CREATE TABLE IF NOT EXISTS fact_payments (
    order_id VARCHAR(32) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(30) NOT NULL,
    payment_installments INT NOT NULL,
    payment_value DECIMAL(12,2) NOT NULL,

    PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_payment_orders
        FOREIGN KEY (order_id)
        REFERENCES fact_orders(order_id)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;

SHOW TABLES LIKE 'fact_%';
