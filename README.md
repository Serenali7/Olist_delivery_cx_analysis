# E-commerce Delivery Performance & Customer Experience
> **Delay Drivers and Customer Impact Analysis**

## 1. Background & Business Context
In the e-commerce industry, fulfillment capability is not just an operational cost—it is a core driver of customer retention. This project utilizes the **Olist Brazilian E-Commerce Dataset** (100k+ real orders) to analyze how delivery performance directly shapes customer experience.

**Key Business Questions:**
1. **Satisfaction Correlation:** To what extent does delivery delay impact our average Review Scores?
2. **Bottleneck Diagnosis:** Is the delay caused by sellers (slow dispatch) or logistics partners (slow last-mile delivery)?
3. **Risk Distribution:** Which geographic regions or seller segments are the primary contributors to fulfillment failure?
4. **Early Warning Signals:** How can we establish operational metrics to detect logistics risks before negative reviews spike?


## 2. Data Source
* **Dataset:** Brazilian E-Commerce Public Dataset by Olist (available on Kaggle). 
  https://www.kaggle.com/api/v1/datasets/download/olistbr/brazilian-ecommerce
* **Scale:** 100,000+ orders spanning 2016 to 2018.
* **Key Tables:** Orders, Order Items, Reviews, Sellers, Customers, Products, and Geolocation.
* **Data Limitations:** * Historical data (pre-2018) may not reflect current infrastructure improvements.
    * The overall repeat purchase rate is naturally low (~3%-5%); analysis focuses on the relative difference in retention intent between "On-time" vs. "Late" groups.


## 3. Key Metric Definitions
The following metrics are defined to quantify performance:

| Metric | Definition / Formula | Business Value |
| :--- | :--- | :--- |
| **Late Delivery Rate** | # of Late Orders / Total Orders | Measures overall fulfillment reliability. |
| **Seller Prep Time** | `shipping_limit_date` - `purchase_time` | Evaluates seller warehouse efficiency. |
| **Carrier Lead Time** | `delivered_customer` - `delivered_carrier` | Measures third-party logistics (3PL) performance. |
| **Review Score Gap** | Avg. Score (On-time) - Avg. Score (Late) | Quantifies brand equity loss due to delays. |
| **Rolling Late Rate** | Late rate over the last 7 or 28 days | Acts as a proactive operational health indicator. |


## 4. Analysis Framework

### 4.1 Fulfillment Lead Time Decomposition
The order lifecycle is decomposed into three stages to pinpoint bottlenecks:
* **Stage 1: Order → Approval:** Time taken for payment clearance and fraud check.
* **Stage 2: Approval → Carrier (Seller Time):** Time taken by the seller to pick, pack, and hand over to the carrier.
* **Stage 3: Carrier → Customer (Logistics Time):** Time taken for the "last-mile" delivery.

### 4.2 Impact on Customer Experience
* **Score Decay:** Quantifying the correlation between days of delay and `review_score`.
* **Satisfaction Threshold:** Identifying the "breaking point" where customer dissatisfaction turns into 1-star reviews.
* **Repeat Purchase Proxy:** Analyzing the behavioral difference in future purchase intent between on-time and delayed customers.

### 4.3 Segment Analysis
* **Geospatial Analysis:** Using `geolocation` data to map late delivery hotspots across Brazilian states (e.g., SP vs. North regions).
* **Seller Tiering:** * **Tier A (Top):** On-time rate > 95%.
    * **Tier C (High Risk):** On-time rate < 80% (Targets for operational intervention).


## 5. Key Findings
*(Note: Replace 'X' with your specific analysis results)*
* **Delay Impact:** Delayed orders result in an average review score decrease of **X.X points**.
* **Primary Bottleneck:** Over **X%** of delays originate in the `Shipped → Delivered` stage, primarily due to long-haul logistics in specific states.
* **Threshold Effect:** Once a delay exceeds **X days**, the probability of receiving a 1-star review increases by **X%**.


## 6. Business Recommendations
1. **Dynamic Estimated Delivery Date (EDD):** Implement more conservative EDDs for high-risk regions to manage customer expectations.
2. **Seller Performance Governance:** Enforce stricter SLAs for Tier C sellers; implement "search de-ranking" for sellers who consistently miss dispatch windows.
3. **Logistics Monitoring Dashboard:** Monitor the 7-day Rolling Late Rate to identify regional logistics failures before they impact monthly KPIs.


## 7. Tools & Skills
* **Language:** Python (Pandas for cleaning, Matplotlib/Seaborn for visualization).
* **Analytics Skills:** Descriptive Statistics, Root Cause Analysis, Business Metric Design, Geospatial Analysis.

