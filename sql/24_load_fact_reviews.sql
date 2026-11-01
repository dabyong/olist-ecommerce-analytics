
USE olist_ecommerce;

INSERT INTO fact_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    r.review_id,
    r.order_id,
    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_creation_date,
    r.review_answer_timestamp
FROM stg_reviews r
WHERE NOT EXISTS (
    SELECT 1
    FROM fact_reviews f
    WHERE f.review_id = r.review_id
      AND f.order_id = r.order_id
);
