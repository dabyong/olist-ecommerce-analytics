
USE olist_ecommerce;

-- LOAD CUSTOMERS
INSERT INTO dim_customers
SELECT s.*
FROM stg_customers s
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_customers d
    WHERE d.customer_id = s.customer_id
);


-- LOAD PRODUCTS WITH CATEGORY FALLBACK
INSERT INTO dim_products (
    product_id,
    product_category_name,
    category_name_english,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    p.product_id,
    p.product_category_name,
    COALESCE(
        t.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ),
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM stg_products p
LEFT JOIN stg_category_translation t
    ON p.product_category_name =
       t.product_category_name
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_products d
    WHERE d.product_id = p.product_id
);


-- LOAD SELLERS
INSERT INTO dim_sellers
SELECT s.*
FROM stg_sellers s
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_sellers d
    WHERE d.seller_id = s.seller_id
);
