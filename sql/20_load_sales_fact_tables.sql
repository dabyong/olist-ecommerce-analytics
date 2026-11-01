
USE olist_ecommerce;

-- ===================================
-- LOAD ORDER ITEMS
-- ===================================

INSERT INTO fact_order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT
    i.order_id,
    i.order_item_id,
    i.product_id,
    i.seller_id,
    i.shipping_limit_date,
    i.price,
    i.freight_value
FROM stg_order_items i
WHERE NOT EXISTS (
    SELECT 1
    FROM fact_order_items f
    WHERE f.order_id = i.order_id
      AND f.order_item_id = i.order_item_id
);


-- ===================================
-- LOAD PAYMENTS
-- ===================================

INSERT INTO fact_payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    p.order_id,
    p.payment_sequential,
    p.payment_type,
    p.payment_installments,
    p.payment_value
FROM stg_order_payments p
WHERE NOT EXISTS (
    SELECT 1
    FROM fact_payments f
    WHERE f.order_id = p.order_id
      AND f.payment_sequential = p.payment_sequential
);
