# Olist E-Commerce: Business Insights & Strategic Recommendations

**Project Scope:** E-Commerce Business Intelligence & Revenue Analytics

**Tech Stack:** Python | MySQL 8 | Power BI

**Dataset:** Brazilian E-Commerce Public Dataset by Olist

**Analysis Period:** September 2016 – August 2018

---

## Executive Summary

Analysis of **96,478 delivered orders** from September 2016 through August 2018 identified **R$13.22M in delivered Gross Merchandise Value (GMV)**, measured using recorded product selling prices excluding freight.

The findings reveal three important business patterns: one-time buyers contributed **94.49% of delivered GMV**, São Paulo-based sellers generated **64.36% of delivered GMV**, and late deliveries were associated with average customer review scores **2.02 points lower** than those of on-time or early deliveries.

These findings highlight potential opportunities to improve repeat purchasing, address geographic seller concentration, and strengthen delivery reliability.

Strategic priorities include evaluating customer retention initiatives, diversifying seller participation across regions, and monitoring delivery performance to identify operational bottlenecks.

The accompanying Power BI dashboard provides interactive historical reporting across merchandise sales, product and seller performance, customer purchasing behavior, and delivery satisfaction.

---

## Key Performance Indicators (KPIs)

| Metric | Value | Executive Context |
|---|---:|---|
| **Delivered GMV** | **R$13,221,498.11** | Total recorded item selling prices from delivered orders, excluding freight |
| **Delivered Orders** | **96,478** | Orders marked as delivered within the observation period |
| **Active Sellers** | **2,970** | Unique sellers with at least one delivered order item |
| **Unique Buyers** | **93,358** | Distinct observed shoppers identified through `customer_unique_id` |
| **Repeat Buyer Rate** | **3.00%** | Share of buyers with at least two delivered orders during the observation period |
| **Late Delivery Rate** | **6.77%** | Share of eligible deliveries arriving after their estimated delivery date |
| **Avg. Delivery Time** | **12.56 Days** | Average duration from purchase to customer delivery |

> **Financial Scope Note:** Delivered GMV represents recorded merchandise selling prices from orders marked as delivered, excluding freight. This operational performance metric is not equivalent to audited accounting revenue and does not incorporate all potential refunds, returns, commissions, or revenue-recognition adjustments.

---

## Detailed Business Findings & Recommendations

### 1. Merchandise Sales Growth & Monthly Trends

**Key Findings**

- **November 2017 Sales Peak:** Delivered GMV reached **R$987,765.37**, representing a **52.37% month-over-month increase** compared with October 2017. The increase coincided with the Black Friday shopping period, although the dataset does not provide sufficient promotional information to establish Black Friday as the primary cause.

- **December 2017 Decline:** GMV decreased by **26.50% month-over-month** following November's peak. Sales subsequently recovered in January 2018, increasing by 27.36% compared with December.

- **2018 Sales Performance:** Between January and July 2018, monthly delivered GMV ranged from approximately **R$826K to R$978K**, indicating sustained merchandise sales activity at a higher level than most months of 2017.

**Strategic Recommendations**

Investigate category-level sales volume and merchandise value during peak shopping periods to identify which product segments contributed most to seasonal increases.

Develop promotional planning strategies based on historical purchasing trends, including product demand, average order value, and monthly order volume.

Where additional historical and campaign data become available, conduct year-over-year comparisons and evaluate promotional effectiveness to distinguish recurring seasonal demand from temporary sales spikes.

---

### 2. Product Category Performance & Volume vs. Value Dynamics

**Key Findings**

- **Leading Product Category:** `Health & Beauty` generated **R$1,233,131.72**, representing **9.33% of total delivered GMV**.

- **Merchandise Value Concentration:** The five leading categories, `Health & Beauty`, `Watches & Gifts`, `Bed, Bath & Table`, `Sports & Leisure`, and `Computers & Accessories`, collectively contributed approximately **39.83% of total delivered GMV**.

- **Sales Volume vs. Merchandise Value:** `Bed, Bath & Table` recorded **10,953 items sold**, exceeding `Health & Beauty` at 9,465 items. However, `Health & Beauty` generated greater merchandise value, demonstrating the importance of evaluating both transaction volume and item selling prices.

**Strategic Recommendations**

Prioritize merchandising and inventory analysis for high-merchandise-value categories while identifying opportunities to improve fulfillment efficiency for high-volume product segments.

For categories such as `Health & Beauty`, investigate product availability, demand consistency, and opportunities to expand the assortment of commercially successful products.

For high-volume categories such as `Bed, Bath & Table`, evaluate fulfillment efficiency, shipping costs, and potential product bundling strategies.

Before making profitability-based investment decisions, integrate product acquisition costs, seller commissions, and operating expenses to assess actual category margins.

---

### 3. Seller Distribution & Geographic Concentration

**Key Findings**

- **Geographic Merchandise Value Concentration:** Sellers located in **São Paulo (SP)** generated **R$8,509,511.46**, accounting for **64.36% of total delivered GMV**.

- **Seller Concentration:** São Paulo accounted for **1,769 active sellers**, representing approximately **59.56% of all active sellers**.

- **Secondary Seller Regions:** Paraná (PR), Minas Gerais (MG), and Rio de Janeiro (RJ) were among the next leading seller locations by delivered merchandise value, although their contributions were substantially smaller than São Paulo's.

**Strategic Recommendations**

Evaluate the potential business risks associated with geographic seller concentration, particularly dependence on one region for a substantial portion of marketplace merchandise sales.

Explore opportunities to expand seller participation in secondary regions such as Paraná, Minas Gerais, and Rio de Janeiro.

Investigate regional fulfillment partnerships and logistics infrastructure to determine whether geographic diversification could improve shipping efficiency, delivery reliability, or marketplace coverage.

Any expansion strategy should be supported by further analysis of regional customer demand, seller capacity, operating costs, and logistics performance.

---

### 4. Customer Repeat Purchasing & Monetization Opportunities

**Key Findings**

- **Low Observed Repeat Purchase Rate:** Only **2,801 out of 93,358 unique buyers (3.00%)** placed at least two delivered orders during the available observation period.

- **Merchandise Value Contribution:** One-time buyers generated **R$12,493,089.36 (94.49%)** of delivered GMV, while repeat buyers contributed **R$728,408.75 (5.51%)**.

- **Purchase Frequency:** Customers placed an average of approximately **1.03 delivered orders per buyer**, indicating that most observed purchasing activity involved a single completed transaction.

These results describe observed purchasing behavior within the dataset. They do not independently establish long-term customer retention or loyalty because purchases outside the observation period are unavailable.

**Strategic Recommendations**

Investigate opportunities to encourage second purchases through targeted post-purchase communication, personalized product recommendations, and relevant cross-selling campaigns.

Consider testing replenishment reminders or loyalty incentives for product categories where repeat purchasing is commercially appropriate.

A potential starting point is to evaluate follow-up campaigns within **30–60 days after delivery**, subject to customer purchasing cycles and product characteristics.

Implement cohort-based analysis using consistent observation windows to distinguish first-time buyers, returning buyers, and customers with sufficient time to make repeat purchases.

Where additional marketing data are available, evaluate customer acquisition costs, customer lifetime value, and campaign performance before allocating substantial resources to retention initiatives.

---

### 5. Delivery Timeliness & Customer Review Scores

**Key Findings**

- **Delivery Delays:** Of **96,470 eligible delivered orders**, **6,534 (6.77%)** arrived after their estimated delivery date.

- **Customer Review Differences:** On-time or early deliveries received an average order-level review score of **4.29/5**, compared with **2.27/5** for late deliveries, representing a **2.02-point difference**.

- **Severe Delivery Delays:** Orders arriving **eight or more days late** received an average review score of **1.70/5**, substantially below the ratings associated with earlier deliveries.

- **Delivery Duration:** The average purchase-to-delivery duration across eligible orders was **12.56 days**.

The observed relationship suggests that delivery timeliness is an important indicator associated with customer satisfaction. However, the analysis does not prove that delays directly caused lower ratings, as other factors such as product quality, seller communication, and service experience may influence customer feedback.

**Strategic Recommendations**

Develop early-warning logistics monitoring for shipments approaching or exceeding their estimated delivery dates.

Establish delivery performance scorecards to compare sellers and logistics operations using indicators such as estimated-versus-actual delivery time, late delivery frequency, and average delay duration.

Prioritize investigation of orders experiencing delays of four or more days, particularly because these orders were associated with substantially lower average customer review scores.

Where carrier identifiers and contractual service-level agreements become available, extend the analysis to evaluate carrier-specific performance and formal SLA compliance.

Use these findings to identify operational improvement opportunities while conducting additional analysis to determine the factors contributing to delivery delays and customer dissatisfaction.

---

## Data Governance & Analytical Methodology

### 1. Financial Reconciliation & Duplicate Prevention

The source data contained differences between recorded item values, freight charges, and payment totals.

An aggregate financial difference of **R$165,318.88** was identified, with the largest contributions coming from canceled and unavailable orders.

To maintain consistent business reporting, delivered GMV was calculated using recorded item selling prices associated with orders marked as `delivered`.

Order items and payments were aggregated independently at the order level before reconciliation to prevent duplicate financial values caused by one-to-many relationships.

Customer reviews were similarly aggregated to the order level when analyzing delivery performance, ensuring that orders with multiple review records did not artificially increase delivery counts.

These controls improved analytical consistency but do not replace full accounting reconciliation.

### 2. Customer Identification & Repeat Purchase Measurement

Customer analysis used `customer_unique_id` to identify shoppers across multiple orders.

A repeat buyer was defined as a shopper with at least two delivered orders within the available historical period.

Because purchasing history outside the dataset is unavailable, the observed repeat buyer rate should not be interpreted as a complete customer retention metric.

Additional cohort analysis and longer observation windows would be required to assess customer retention more accurately.

### 3. Delivery Performance Measurement

Delivery timeliness was evaluated by comparing actual customer delivery dates against estimated delivery dates.

Orders delivered after the estimated calendar date were classified as late.

These estimates provide a useful operational benchmark but should not be interpreted as formal contractual service-level agreements without additional supporting information.

Review ratings were analyzed at the order level to avoid inflating results from orders containing multiple review records.

### 4. Historical Coverage & Data Limitations

The dataset contains historical transactions from September 2016 through August 2018.

September 2016 and August 2018 have incomplete monthly coverage, while certain early months contain unusually low transaction volumes. These periods require caution when interpreting month-over-month growth.

The dataset also lacks several important business inputs, including:

- Product acquisition costs and profit margins
- Marketing spend and promotional attribution
- Customer acquisition costs (CAC)
- Complete refund and return information
- Seller commission structures
- Carrier-level operating costs and formal SLA records
- Website traffic and product impressions needed for conversion-rate analysis

These limitations restrict profitability analysis, promotional effectiveness measurement, and causal interpretation of operational performance.

---

## Conclusion & Strategic Roadmap

This analysis identifies **five business priorities** that warrant further investigation:

1. **Strengthening Sales Planning:** Understand recurring demand patterns and identify opportunities to improve performance outside peak shopping periods.

2. **Optimizing Product Strategy:** Balance high-merchandise-value and high-volume categories while incorporating cost and margin information into future decisions.

3. **Diversifying Seller Participation:** Evaluate opportunities to reduce geographic concentration and strengthen marketplace coverage beyond São Paulo.

4. **Encouraging Repeat Purchasing:** Investigate customer lifecycle strategies designed to improve second-purchase activity and support longer-term customer relationships.

5. **Improving Delivery Reliability:** Monitor delivery delays, investigate logistics bottlenecks, and evaluate operational improvements that may contribute to better customer experiences.

The accompanying **four-page interactive Power BI dashboard** provides historical visibility into merchandise sales, product and seller performance, customer purchasing behavior, and delivery satisfaction.

Future analytical development may incorporate customer cohort retention tracking, seller commission modeling, promotional effectiveness analysis, and logistics cost optimization.

By combining structured data preparation, relational database modeling, financial reconciliation, SQL business analysis, and interactive visualization, this project demonstrates how historical e-commerce data can support practical, evidence-based business recommendations.