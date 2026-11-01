
USE olist_ecommerce;

CREATE TABLE IF NOT EXISTS stg_geolocation (
    geolocation_zip_code_prefix VARCHAR(5),
    geolocation_lat DOUBLE,
    geolocation_lng DOUBLE,
    geolocation_city VARCHAR(255),
    geolocation_state VARCHAR(2)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;

-- Verify table creation
SHOW TABLES LIKE 'stg_geolocation';
