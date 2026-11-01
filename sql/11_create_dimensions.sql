
USE olist_ecommerce;

-- =========================================
-- DIMENSION 1: CUSTOMERS
-- =========================================

CREATE TABLE IF NOT EXISTS dim_customers (
    customer_id VARCHAR(32) NOT NULL,
    customer_unique_id VARCHAR(32) NOT NULL,
    customer_zip_code_prefix VARCHAR(5),
    customer_city VARCHAR(100),
    customer_state VARCHAR(2),

    PRIMARY KEY (customer_id),
    INDEX idx_customer_unique (customer_unique_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- =========================================
-- DIMENSION 2: PRODUCTS
-- =========================================

CREATE TABLE IF NOT EXISTS dim_products (
    product_id VARCHAR(32) NOT NULL,
    product_category_name VARCHAR(100),
    category_name_english VARCHAR(255) NOT NULL,
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(12,2),
    product_length_cm DECIMAL(12,2),
    product_height_cm DECIMAL(12,2),
    product_width_cm DECIMAL(12,2),

    PRIMARY KEY (product_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- =========================================
-- DIMENSION 3: SELLERS
-- =========================================

CREATE TABLE IF NOT EXISTS dim_sellers (
    seller_id VARCHAR(32) NOT NULL,
    seller_zip_code_prefix VARCHAR(5),
    seller_city VARCHAR(100),
    seller_state VARCHAR(2),

    PRIMARY KEY (seller_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- Verify tables
SHOW TABLES LIKE 'dim_%';
