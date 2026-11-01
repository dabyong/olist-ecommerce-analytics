

USE olist_ecommerce;

-- 1. Identify repeated review IDs
SELECT
    review_id,
    COUNT(*) AS occurrences,
    COUNT(DISTINCT order_id) AS distinct_orders
FROM stg_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC
LIMIT 10;


-- 2. Check duplicate review_id + order_id pairs
SELECT
    COUNT(*) AS duplicate_review_order_pairs
FROM (
    SELECT review_id, order_id
    FROM stg_reviews
    GROUP BY review_id, order_id
    HAVING COUNT(*) > 1
) AS duplicates;


-- 3. Identify orders with multiple review records
SELECT
    order_id,
    COUNT(*) AS review_count
FROM stg_reviews
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY review_count DESC
LIMIT 10;


-- 4. Identify untranslated product categories
SELECT
    p.product_category_name,
    COUNT(*) AS affected_products
FROM stg_products p
LEFT JOIN stg_category_translation t
    ON p.product_category_name =
       t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL
GROUP BY p.product_category_name
ORDER BY affected_products DESC;
