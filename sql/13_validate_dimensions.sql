
USE olist_ecommerce;

-- Customer dimension validation
SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM dim_customers;

-- Product dimension validation
SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT product_id) AS unique_products,
    SUM(category_name_english = 'Unknown')
        AS unknown_categories
FROM dim_products;

-- Seller dimension validation
SELECT
    COUNT(*) AS total_sellers,
    COUNT(DISTINCT seller_id) AS unique_sellers
FROM dim_sellers;
