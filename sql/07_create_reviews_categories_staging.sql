
USE olist_ecommerce;

CREATE TABLE IF NOT EXISTS stg_reviews (
    review_id VARCHAR(32),
    order_id VARCHAR(32),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS stg_category_translation (
    product_category_name VARCHAR(255),
    product_category_name_english VARCHAR(255)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;

SHOW TABLES LIKE 'stg_reviews';
SHOW TABLES LIKE 'stg_category_translation';
