
USE olist_ecommerce;

-- Validate review records
SELECT
    COUNT(*) AS total_reviews,
    COUNT(DISTINCT review_row_id) AS unique_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids,
    COUNT(DISTINCT order_id) AS orders_with_reviews,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM fact_reviews;

-- Verify the foreign key relationships
SELECT COUNT(*) AS orphan_reviews
FROM fact_reviews r
LEFT JOIN fact_orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Check rating distribution
SELECT
    review_score,
    COUNT(*) AS review_count
FROM fact_reviews
GROUP BY review_score
ORDER BY review_score;
