
USE olist_ecommerce;

-- 1. Review table cardinality
SELECT
    COUNT(*) AS total_reviews,
    COUNT(DISTINCT review_id) AS unique_review_ids,
    COUNT(DISTINCT order_id) AS orders_with_reviews,
    SUM(review_id IS NULL) AS null_review_ids
FROM stg_reviews;

-- 2. Check duplicate Order Item composite keys
SELECT COUNT(*) AS duplicate_item_keys
FROM (
    SELECT order_id, order_item_id
    FROM stg_order_items
    GROUP BY order_id, order_item_id
    HAVING COUNT(*) > 1
) AS duplicates;

-- 3. Check duplicate Payment composite keys
SELECT COUNT(*) AS duplicate_payment_keys
FROM (
    SELECT order_id, payment_sequential
    FROM stg_order_payments
    GROUP BY order_id, payment_sequential
    HAVING COUNT(*) > 1
) AS duplicates;

-- 4. Identify untranslated product categories
SELECT
    COUNT(DISTINCT p.product_category_name)
        AS categories_without_translation
FROM stg_products p
LEFT JOIN stg_category_translation t
    ON p.product_category_name =
       t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;
