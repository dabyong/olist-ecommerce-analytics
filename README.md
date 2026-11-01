# E-Commerce Business Intelligence & Revenue Analytics

**End-to-End Data Analytics Portfolio Project | Python • MySQL • Power BI**

## Project Overview

This project develops an end-to-end Business Intelligence solution using the Brazilian E-Commerce Public Dataset by Olist.

The objective is to transform raw transactional data into a validated relational database, analyze business performance, and build an interactive Power BI dashboard that supports data-driven business decisions.

The project demonstrates practical skills in data engineering, SQL analytics, data modeling, financial reconciliation, business intelligence, and analytical storytelling.

## Business Objectives

The analysis focuses on five business questions:

1. How did merchandise sales perform over time?
2. Which products, categories, and sellers contribute the most merchandise value?
3. What purchasing patterns distinguish one-time and repeat buyers?
4. How is seller activity distributed geographically?
5. How are delivery delays associated with customer satisfaction?

## Technology Stack

| Technology | Application |
|---|---|
| Python 3.12 | Data profiling, anomaly detection, preparation, and ETL |
| Pandas | Dataset inspection and transformation |
| MySQL 8.4 | Relational database, SQL modeling, and business analytics |
| Power BI Desktop | Interactive dashboards and DAX measures |
| Kiro IDE | Development environment |
| Git & GitHub | Version control and project documentation |

## Data Source

**Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

The dataset contains approximately 100,000 historical orders and nine interconnected CSV datasets covering customers, orders, products, sellers, payments, reviews, and geographic information.

**Analysis period:** September 2016 – August 2018.

## Technical Architecture

The solution follows a structured analytics workflow:

**Olist CSV Datasets → Python Data Profiling & Preparation → MySQL Staging Tables → Relational Fact & Dimension Tables → SQL Analytics Views → Power BI Dashboards**

### Data Preparation

Python scripts were developed to perform:

- Dataset profiling and missing-value analysis
- Duplicate-key and relationship validation
- Order anomaly detection
- Data quality flagging
- Repeatable CSV-to-MySQL loading
- Import row-count verification

The raw source data was preserved. Questionable records were flagged rather than automatically deleted.

### Database Design

The analytics database includes three core dimensions:

- `dim_customers`
- `dim_products`
- `dim_sellers`

And four transaction tables:

- `fact_orders`
- `fact_order_items`
- `fact_payments`
- `fact_reviews`

Primary keys, foreign keys, and validation queries were implemented to maintain relational integrity.

### SQL Business Analytics

Reusable SQL views support:

- Financial reconciliation
- Monthly merchandise sales and growth
- Product and category rankings
- Seller and geographic performance
- Repeat-purchase analysis
- Delivery performance and customer satisfaction

One-to-many relationships were handled carefully to prevent duplicated financial totals.

## Power BI Dashboard

The final Power BI report contains four interactive pages.

### 1. Executive Sales Overview

Monitors delivered merchandise value, delivered orders, average order value, and monthly sales growth.

### 2. Product & Seller Performance

Identifies top product categories, leading sellers, active merchants, and regional seller concentration.

### 3. Customer Analytics

Explores unique buyers, repeat purchasing, customer segments, geographic distribution, and merchandise value contributions.

### 4. Delivery & Customer Satisfaction

Evaluates delivery timeliness, late delivery rates, review scores, and rating patterns across delivery-delay categories.

The dashboards include interactive Year Slicers and measures that respond to report filters.

## Key Business Findings

| KPI | Result |
|---|---:|
| Delivered Gross Merchandise Value | R$13.22M |
| Delivered Orders | 96,478 |
| Active Sellers | 2,970 |
| Unique Buyers | 93,358 |
| Repeat Buyer Rate | 3.00% |
| Late Delivery Rate | 6.77% |
| Average Delivery Duration | 12.56 days |

### Major Insights

**Sales Performance:** November 2017 recorded R$987,765.37 in delivered merchandise value, representing 52.37% month-over-month growth.

**Product Performance:** Health & Beauty generated the highest category merchandise value at R$1.23M.

**Seller Concentration:** São Paulo-based sellers contributed approximately 64.36% of delivered merchandise value.

**Customer Behavior:** Only 3.00% of observed buyers made multiple delivered purchases during the available period.

**Delivery Satisfaction:** Late deliveries received average order-level review scores of 2.27/5, compared with 4.29/5 for on-time or early deliveries.

The delivery findings represent an observed association, not proof of causation.

## Business Recommendations

The analysis suggests opportunities to investigate:

- More targeted sales planning during seasonal demand periods
- Product assortment and fulfillment optimization
- Geographic diversification of marketplace sellers
- Customer second-purchase and retention initiatives
- Earlier detection of delivery delays and logistics bottlenecks

Detailed explanations, limitations, and supporting evidence are available in [Business Insights & Strategic Recommendations](reports/business_insights.md).

## Data Quality & Analytical Limitations

The project includes validation of approximately 1.55 million rows across nine source datasets, order-level financial reconciliation, missing-value analysis, and referential integrity checks.

Delivered GMV represents product selling prices for orders marked as delivered, excluding freight. It is not equivalent to audited accounting revenue.

The historical dataset does not contain complete information on refunds, costs, advertising expenditure, carrier contracts, or long-term customer histories. These limitations were considered when interpreting findings and making recommendations.

## Repository Organization

| Directory | Contents |
|---|---|
| `scripts/` | Python profiling, preparation, and ETL scripts |
| `sql/` | Database schema, fact and dimension loads, validation, analytics views |
| `reports/` | Data quality outputs and business insights |
| `dashboard/` | Power BI report |
| `assets/` | Dashboard screenshots and documentation images |
| `data/` | Local raw and processed datasets (excluded from Git) |

## Reproducing the Analysis

1. Install Python 3.12, MySQL 8.x, and Power BI Desktop.
2. Download the original Olist CSV datasets from Kaggle.
3. Place the nine CSV files in `data/raw/`.
4. Create a Python virtual environment and install the project dependencies.
5. Configure local MySQL connection credentials using a private `.env` file.
6. Run the Python profiling and preparation scripts.
7. Execute the SQL schema scripts and load the validated staging data.
8. Create the relational model and SQL analytics views in their documented dependency order.
9. Open the Power BI report, configure the local MySQL data source, and refresh the imported data.

Database credentials and the original large datasets are intentionally excluded from version control.

## Future Improvements

- Cohort-based customer retention analysis
- Product profitability and seller commission analysis
- Advanced customer segmentation
- Automated data quality testing
- Incremental data loading and scheduled refresh
- Promotional and logistics cost analysis

## Project Status

**Dashboard development and business analysis complete.** Final repository documentation and publication preparation are in progress.

---

**Project Type:** Individual Data Analytics Portfolio Project

**Primary Skills Demonstrated:** Python ETL, SQL, Relational Data Modeling, Data Quality Assurance, DAX, Power BI, Financial Reconciliation, and Business Analysis.