# E-commerce Delivery Performance & Customer Experience

## 1.Executive Summary
This project analyzes 100k+ real orders from the Brazilian Olist marketplace (2016–2018) to quantify how delivery reliability impacts customer satisfaction and identify operational drivers behind late deliveries.
**Key finding:**
Even a 7.87% late rate materially impacts customer experience, with late deliveries associated with a 1.9-point drop in review score.

The analysis decomposes delays into seller-driven vs carrier-driven components and identifies geographic and temporal risk concentration patterns.

## 2. Business Context
**In e-commerce, delivery reliability directly influences:**
- Customer satisfaction
- Repeat purchase behavior
- Brand trust
- Operational cost
**This project addresses four core business questions:**
- How strongly does delivery delay impact review scores?
- Are delays primarily seller-driven or carrier-driven?
- Where are delay risks geographically concentrated?
- When are late delivery risks seasonally elevated?

## 2. Analytics Architecture
<img width="1071" height="535" alt="Screenshot 2026-02-19 at 15 31 34" src="https://github.com/user-attachments/assets/9f920f32-0fd4-4a00-b46a-328fd2a9bb03" />

## 3.Dashboard Overview
Two executive dashboards were built to separate customer impact from operational diagnosis.

### Dashboard 1 – Customer Impact & Trend
<img width="988" height="787" alt="Screenshot 2026-02-19 at 14 12 22" src="https://github.com/user-attachments/assets/8ffae9f4-0725-47f9-a8ac-2843233d05a2" />
**Focuses:**
- Late Rate KPI
- Average Delay
- Review Score Impact Analysis
- Late Rate by Review Level
This dashboard quantifies how logistics reliability translates into measurable customer experience shifts.

### Dashboard 2 – Operational Diagnosis
<img width="984" height="786" alt="Screenshot 2026-02-19 at 14 13 20" src="https://github.com/user-attachments/assets/a070c001-0a27-4a20-99c0-cc9344337304" />
**Focuses:**
- Carrier vs Seller Delay Attribution
- Delivery Component Comparison
- State-Level Risk Matrix
- High-Risk Time Period Identification
This dashboard identifies structural bottlenecks and risk concentration drivers.

## 4. Key Performance Metrics
|Metric	              |  Value     |
|-------------------- |----------- |
|Late Rate            |  7.87%     |
|Avg Carrier Time     |  9.28 days |
|Avg Delay (Late Only)|  10.62 days|
|Avg Seller Prep Time |  2.71 days |

Even a single-digit late rate translates into thousands of affected customers at this scale.

## 5. Key Insights
### 5.1 Delivery Delay Strongly Damages Customer Satisfaction
Late deliveries result in a **1.9-point drop** in review score:
| Delivery Status | Avg Review |
|-----------------|------------|
|   Late          | 2.271      |
|   On-time       | 4.212      |

Customer satisfaction drops sharply when delivery is late.
Delivery reliability directly influences reputation risk.

### 5.2 Late Delivery Rate Decreases as Review Score Increases
<img width="517" height="723" alt="Screenshot 2026-02-19 at 13 54 11" src="https://github.com/user-attachments/assets/c7c7183e-0285-4cdb-802a-96bae23fbfc7" />

**Customer Ratings Reflect Delivery Risk**
Late delivery probability drops sharply as review scores increase:
- ~30% late rate for 1★ reviews
- <2% late rate for 5★ reviews

This demonstrates a strong negative correlation between logistics performance and customer satisfaction.

### 5.3 Bottleneck Diagnosis: Carrier is the Primary Risk Driver

<img width="1050" height="250" alt="Screenshot 2026-02-19 at 13 58 02" src="https://github.com/user-attachments/assets/5711acfa-face-4cd9-a529-6ecf239a6b9e" />

Among late orders:
- ~80% are carrier-driven
- Seller-driven delays account for ~15–18%
- Mixed cases are minimal
**Insight:**  
- Last-mile logistics performance, rather than warehouse prep time, is the dominant contributor to late delivery.
- Operational focus should prioritize carrier management rather than seller SLAs.

### 5.4 Delivery Component Comparison
**Insight:**
- Carrier time fluctuates significantly across months, while seller prep time remains relatively stable.
- This suggests that volatility in logistics networks contributes more heavily to delay risk than warehouse operations.

### 5.5 Risk Concentration: State-Level Performance Matrix
<img width="889" height="717" alt="Screenshot 2026-02-19 at 13 56 34" src="https://github.com/user-attachments/assets/8ef23c57-6459-4d1f-b414-30412d359a31" />
**State-level matrix reveals:**
- High late-rate & high seller-prep zones
- High late-rate but normal prep → carrier-driven regions
This enables targeted SLA renegotiation and risk-weighted monitoring strategies.

### 5.6 Seasonal Risk Concentration
<img width="388" height="725" alt="Screenshot 2026-02-19 at 13 59 43" src="https://github.com/user-attachments/assets/f0ebe5ae-4706-4e54-849b-c7f4c77ed4b7" />
**Certain months exhibit significantly elevated late rates, suggesting:**
- Capacity constraints
- Seasonal surges
- Logistics volatility

## 6. Business Recommendations
### 6.1 Carrier-Focused Optimization 
- Monitor carrier-driven delays
- Reallocate volume away from underperforming regions
### 6.2 Customer Impact Monitoring
- Track late rate alongside review score metrics
- Implement early-warning thresholds
### 6.3 State-Level Risk Governance
- Intervene in high-risk geographic clusters
- Adjust SLAs regionally

## 7. Technical Implementation
**Data Modeling**
- Star schema (fact_orders + dimension tables)
- Order-level metric engineering
- Delay decomposition logic
- Rolling window late rate calculations
**Tools**
- SQL (primary transformation engine)
- Tableau (dashboard layer)
**Dataset**
- Brazilian E-Commerce Public Dataset by Olist (Kaggle)  
- 2016–2018  
- 100k+ orders
