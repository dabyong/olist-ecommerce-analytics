
USE olist_ecommerce;

-- =========================================
-- STEP 28: MONTH-OVER-MONTH SALES GROWTH
-- =========================================

WITH monthly_data AS (
    SELECT
        purchase_month,
        delivered_orders,
        merchandise_value,
        average_order_value,

        LAG(purchase_month) OVER (
            ORDER BY purchase_month
        ) AS previous_month,

        LAG(merchandise_value) OVER (
            ORDER BY purchase_month
        ) AS previous_month_sales

    FROM vw_monthly_sales_kpis
)

SELECT
    purchase_month,
    delivered_orders,
    merchandise_value,
    previous_month_sales,

    CASE
        WHEN previous_month IS NULL
        THEN NULL

        -- Do not compare across missing months
        WHEN TIMESTAMPDIFF(
            MONTH,
            STR_TO_DATE(
                CONCAT(previous_month, '-01'),
                '%Y-%m-%d'
            ),
            STR_TO_DATE(
                CONCAT(purchase_month, '-01'),
                '%Y-%m-%d'
            )
        ) <> 1
        THEN NULL

        WHEN previous_month_sales = 0
        THEN NULL

        ELSE ROUND(
            (
                merchandise_value
                - previous_month_sales
            ) / previous_month_sales * 100,
            2
        )
    END AS mom_growth_pct,

    average_order_value

FROM monthly_data
ORDER BY purchase_month;
