
USE olist_ecommerce;

-- Check reviews referencing nonexistent orders
SELECT COUNT(*) AS orphan_reviews
FROM stg_reviews r
LEFT JOIN fact_orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Check required values and rating range
SELECT
    SUM(review_id IS NULL) AS null_review_ids,
    SUM(order_id IS NULL) AS null_order_ids,
    SUM(review_score IS NULL) AS null_scores,
    SUM(
        review_score NOT BETWEEN 1 AND 5
    ) AS invalid_scores
FROM stg_reviews;

-- Check duplicate composite identifiers
SELECT COUNT(*) AS duplicate_review_order_pairs
FROM (
    SELECT review_id, order_id
    FROM stg_reviews
    GROUP BY review_id, order_id
    HAVING COUNT(*) > 1
) AS duplicates;
