
USE olist_ecommerce;

-- =========================================
-- STEP 27: MONTHLY SALES ANALYSIS
-- =========================================

-- Create an order-level delivered sales view
CREATE OR REPLACE VIEW vw_delivered_order_sales AS

SELECT
    o.order_id,
    DATE(o.order_purchase_timestamp)
        AS purchase_date,

    DATE_FORMAT(
        o.order_purchase_timestamp, '%Y-%m'
    ) AS purchase_month,

    f.item_value,
    f.freight_value,
    f.payment_value,
    f.payment_difference,
    f.missing_items,
    f.missing_payments

FROM fact_orders o

JOIN vw_order_financial_reconciliation f
    ON o.order_id = f.order_id

WHERE o.order_status = 'delivered';


-- =========================================
-- MONTHLY SALES KPI VIEW
-- =========================================

CREATE OR REPLACE VIEW vw_monthly_sales_kpis AS

SELECT
    purchase_month,

    COUNT(*) AS delivered_orders,

    SUM(
        CASE WHEN missing_items = 0
        THEN 1 ELSE 0 END
    ) AS orders_with_items,

    ROUND(SUM(item_value), 2)
        AS merchandise_value,

    ROUND(SUM(freight_value), 2)
        AS freight_value,

    ROUND(SUM(payment_value), 2)
        AS recorded_payment_value,

    ROUND(
        SUM(item_value) /
        NULLIF(
            SUM(
                CASE WHEN missing_items = 0
                THEN 1 ELSE 0 END
            ), 0
        ), 2
    ) AS average_order_value

FROM vw_delivered_order_sales

GROUP BY purchase_month;


-- =========================================
-- DISPLAY MONTHLY RESULTS
-- =========================================

SELECT *
FROM vw_monthly_sales_kpis
ORDER BY purchase_month;


-- =========================================
-- VERIFY OVERALL TOTALS
-- =========================================

SELECT
    SUM(delivered_orders)
        AS total_delivered_orders,

    ROUND(SUM(merchandise_value), 2)
        AS total_merchandise_value,

    ROUND(SUM(freight_value), 2)
        AS total_freight_value,

    ROUND(SUM(recorded_payment_value), 2)
        AS total_payment_value

FROM vw_monthly_sales_kpis;
