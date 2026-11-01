
USE olist_ecommerce;

SELECT
    (
        SELECT COUNT(*)
        FROM stg_order_items i
        LEFT JOIN fact_orders o
            ON i.order_id = o.order_id
        WHERE o.order_id IS NULL
    ) AS items_missing_orders,

    (
        SELECT COUNT(*)
        FROM stg_order_items i
        LEFT JOIN dim_products p
            ON i.product_id = p.product_id
        WHERE p.product_id IS NULL
    ) AS items_missing_products,

    (
        SELECT COUNT(*)
        FROM stg_order_items i
        LEFT JOIN dim_sellers s
            ON i.seller_id = s.seller_id
        WHERE s.seller_id IS NULL
    ) AS items_missing_sellers,

    (
        SELECT COUNT(*)
        FROM stg_order_payments p
        LEFT JOIN fact_orders o
            ON p.order_id = o.order_id
        WHERE o.order_id IS NULL
    ) AS payments_missing_orders;
