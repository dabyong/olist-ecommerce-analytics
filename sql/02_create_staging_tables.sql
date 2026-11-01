
USE olist_ecommerce;

CREATE TABLE IF NOT EXISTS stg_customers (
    customer_id VARCHAR(32),
    customer_unique_id VARCHAR(32),
    customer_zip_code_prefix VARCHAR(5),
    customer_city VARCHAR(100),
    customer_state VARCHAR(2)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4;

SHOW TABLES LIKE 'stg_customers';
