
USE olist_ecommerce;

-- Products staging table
CREATE TABLE IF NOT EXISTS stg_products (
    product_id VARCHAR(32),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(12,2),
    product_length_cm DECIMAL(12,2),
    product_height_cm DECIMAL(12,2),
    product_width_cm DECIMAL(12,2)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- Sellers staging table
CREATE TABLE IF NOT EXISTS stg_sellers (
    seller_id VARCHAR(32),
    seller_zip_code_prefix VARCHAR(5),
    seller_city VARCHAR(100),
    seller_state VARCHAR(2)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

-- Verify tables
SHOW TABLES;
