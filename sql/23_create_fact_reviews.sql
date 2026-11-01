
USE olist_ecommerce;

CREATE TABLE IF NOT EXISTS fact_reviews (

    -- Surrogate primary key
    review_row_id BIGINT AUTO_INCREMENT,

    -- Original review identifiers
    review_id VARCHAR(32) NOT NULL,
    order_id VARCHAR(32) NOT NULL,

    -- Customer feedback
    review_score TINYINT NOT NULL,
    review_comment_title TEXT,
    review_comment_message TEXT,

    -- Review timestamps
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,

    -- Constraints
    PRIMARY KEY (review_row_id),

    UNIQUE KEY uq_review_order (
        review_id, order_id
    ),

    INDEX idx_review_order (order_id),
    INDEX idx_review_score (review_score),

    CONSTRAINT chk_review_score
        CHECK (review_score BETWEEN 1 AND 5),

    CONSTRAINT fk_review_orders
        FOREIGN KEY (order_id)
        REFERENCES fact_orders(order_id)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
