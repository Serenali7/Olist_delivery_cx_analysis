# E-commerce Delivery Performance & Customer Experience

**Delay Drivers and Customer Experience Impact Analysis**  
Olist Brazilian E-Commerce Public Dataset (~100k orders)

![Pipeline Diagram](pipeline_diagram.png)

## 1. Background & Business Context
In the e-commerce industry, fulfillment capability is not just an operational cost—it is a core driver of customer retention. This project utilizes the **Olist Brazilian E-Commerce Dataset** (100k+ real orders) to analyze how delivery performance directly shapes customer experience. 
This analysis focuses on translating delivery performance signals into measurable, actionable operational metrics.

**Key Business Questions:**
1. **Satisfaction Correlation:** To what extent does delivery delay impact our average Review Scores?
2. **Bottleneck Diagnosis:** Is the delay caused by sellers (slow dispatch) or logistics partners (slow last-mile delivery)?
3. **Risk Distribution:** Which geographic regions or seller segments are the primary contributors to fulfillment failure?
4. **Early Warning Signals:** How can we establish operational metrics to detect logistics risks before negative reviews spike?


## 2. Key Metric Definitions
All metrics are computed at the order level unless otherwise specified.
The following metrics are defined to quantify performance:

| Metric | Definition / Formula | Business Value |
| :--- | :--- | :--- |
| **Late Delivery Rate** | # of Late Orders / Total Orders | Measures overall fulfillment reliability. |
| **Seller Prep Time** | `shipping_limit_date` - `purchase_time` | Evaluates seller warehouse efficiency. |
| **Carrier Lead Time** | `delivered_customer` - `delivered_carrier` | Measures third-party logistics (3PL) performance. |
| **Review Score Gap** | Avg. Score (On-time) - Avg. Score (Late) | Quantifies brand equity loss due to delays. |
| **Rolling Late Rate** | Late rate over the last 7 or 28 days | Acts as a proactive operational health indicator. |


## 3. Analysis Framework

### 3.1 Fulfillment Lead Time Decomposition
The order lifecycle is decomposed into three stages to pinpoint bottlenecks:
* **Stage 1: Order → Approval:** Time taken for payment clearance and fraud check.
* **Stage 2: Approval → Carrier (Seller Time):** Time taken by the seller to pick, pack, and hand over to the carrier.
* **Stage 3: Carrier → Customer (Logistics Time):** Time taken for the "last-mile" delivery.

### 3.2 Impact on Customer Experience
* **Score Decay:** Quantifying the correlation between days of delay and `review_score`.
* **Satisfaction Threshold:** Identifying the "breaking point" where customer dissatisfaction turns into 1-star reviews.
* **Repeat Purchase Proxy:** Analyzing the behavioral difference in future purchase intent between on-time and delayed customers.

### 3.3 Segment Analysis
* **Geospatial Analysis:** Using `geolocation` data to map late delivery hotspots across Brazilian states (e.g., SP vs. North regions).
* **Seller Tiering:**
  * **Tier A (Top):** On-time rate > 95%
  * **Tier C (High Risk):** On-time rate < 80% (targets for operational intervention)


## 4. Key Findings(draft)
Detailed quantitative results will be documented after metric validation and diagnostic analysis.
### 4.1 Impact of Delivery Delay on Customer Satisfaction:
  Delivery performance has a strong and nonlinear impact on customer experience. Orders delivered
  late show a 1.73-point average drop in review score compared to on-time deliveries (4.29 vs 2.57).
  <img width="280" height="45" alt="Screenshot 2026-02-06 at 16 23 24" src="https://github.com/user-attachments/assets/f5898091-fa03-4501-9d96-92c5fe45370c" />

  Further bucket analysis reveals a clear satisfaction threshold at 3 days of delay. While short delays (1–2 days)
  lead to moderate dissatisfaction, delays beyond 3 days cause review scores to collapse and 1-star review rates to exceed 48%.
  For delays over 6 days, negative reviews become the dominant outcome, with nearly 70% of orders receiving 1-star ratings.
  <img width="272" height="106" alt="Screenshot 2026-02-06 at 16 24 45" src="https://github.com/user-attachments/assets/de0ae6ad-fe56-45c5-9804-09aae969a68b" />

### 4.2 Bottleneck Diagnosis: Seller vs. Carrier Responsibility
Late deliveries are driven primarily by downstream logistics rather than seller preparation inefficiencies.

Across all orders, late deliveries exhibit both longer seller preparation times and significantly extended carrier lead times. However, the magnitude 
of delay is disproportionately driven by carrier performance. While seller preparation time increases by approximately 2 days for late orders, 
carrier lead time increases by nearly 18 days on average.
<img width="377" height="50" alt="Screenshot 2026-02-06 at 16 43 28" src="https://github.com/user-attachments/assets/153a2ae5-4ac6-467a-81ac-b9c7e81af239" />

Further decomposition by delay severity reveals a clear escalation pattern. As delivery delays increase from 1–2 days to over 10 days, 
average seller preparation time rises gradually, whereas carrier lead time increases sharply and nonlinearly. Orders delayed by more than 10 days 
experience an average carrier lead time exceeding 40 days.
<img width="375" height="108" alt="Screenshot 2026-02-06 at 16 44 10" src="https://github.com/user-attachments/assets/e016a5c1-bb39-491b-a358-120cd34d8f3e" />

Attribution analysis confirms this imbalance: approximately 86% of delayed orders are classified as carrier-driven, compared to only 14% attributed to seller delays. This indicates that last-mile logistics performance is the dominant operational bottleneck affecting fulfillment reliability.
<img width="212" height="66" alt="Screenshot 2026-02-06 at 16 44 46" src="https://github.com/user-attachments/assets/6434478a-8d56-45b9-9981-041c44869e35" />

### 4.3 Risk Segmentation: High-Risk Sellers and Operational Exposure
Seller-level analysis reveals substantial performance heterogeneity across the platform.

After filtering to sellers with sufficient order volume (≥ 50 orders) to ensure statistical reliability, 
late delivery rates vary widely across sellers, indicating that fulfillment risk is not evenly distributed.

A small subset of sellers exhibits consistently elevated late delivery rates, contributing disproportionately to overall fulfillment failures. 
These high-risk sellers represent clear targets for operational intervention, such as SLA renegotiation, seller coaching, or temporary traffic throttling.

This segmentation framework enables the platform to shift from reactive issue handling to proactive risk management by 
focusing resources on structurally underperforming sellers rather than isolated incidents.

### 4.4 Early Warning Signals from Rolling Late Rate
Daily late delivery rates are highly volatile and unsuitable for operational monitoring.  
However, a 7-day rolling late rate provides a stable and interpretable signal that reveals emerging fulfillment risks before customer reviews deteriorate.

Spikes in the rolling late rate often precede sustained periods of high delay frequency, making it a practical early warning indicator for logistics performance.


## 5. Business Recommendations(draft)
### 5.1 SLA Threshold Redesign
Rather than optimizing average delivery time, fulfillment operations should prioritize preventing delays beyond 3 days.
Establishing a 3-day late-delivery threshold as a critical SLA boundary can significantly reduce reputation damage with minimal operational overhead.

### 5.2 Logistics-Focused Intervention Strategy
Given that the majority of delivery delays originate from carrier lead time rather than seller preparation, operational improvement efforts 
should prioritize logistics partners over seller-side process optimization.

Recommended actions include:
- Introducing carrier-level performance monitoring with rolling late-delivery metrics.
- Differentiating SLA thresholds by geographic region to account for last-mile risk.
- Implementing early-warning triggers when carrier lead times exceed historical baselines.
- Rebalancing shipment volume away from consistently underperforming carriers in high-risk regions.

### 5.3 Tier-Based Seller Risk Management
Seller fulfillment risk is highly concentrated among a small subset of sellers.  
Rather than enforcing uniform policies, Olist should apply tier-based seller management:

- Prioritize intervention on high–late-rate sellers with sufficient order volume
- Apply stricter SLA enforcement or traffic throttling for Tier C sellers
- Minimize friction for consistently on-time sellers

### 5.4 Proactive Logistics Risk Monitoring

Olist should operationalize a rolling 7-day late delivery rate as a core monitoring metric.  
When the rolling late rate exceeds predefined thresholds, targeted investigations can be triggered before negative reviews spike.

This shifts fulfillment management from reactive issue handling to proactive risk prevention.

## 6. Data Source
* **Dataset:** Brazilian E-Commerce Public Dataset by Olist (available on Kaggle). 
* **Scale:** 100k+ orders (2016–2018).
* **Core Tables:** Orders, Order Items, Reviews, Sellers, Customers, Products, and Geolocation.
**Notes & Limitations**
- Historical data (pre-2018); patterns may not reflect recent infrastructure improvements.
- Repeat purchase rate is naturally low (~3–5%); analysis focuses on relative behavioral differences between on-time and late deliveries.

## 7. Project Structure
- `pipeline_diagram.png`  
  End-to-end workflow overview
- `/sql/`  
  SQL scripts for metric creation, delay flags, and rolling window analysis
- `/notebooks/`  
  Exploratory analysis and visualization of delivery performance and customer experience

## 8. Tools & Skills
* **Language:** Python (Pandas for cleaning, Matplotlib/Seaborn for visualization).
* **Analytics Skills:** Descriptive Statistics, Root Cause Analysis, Business Metric Design, Geospatial Analysis.

