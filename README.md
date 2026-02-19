# E-commerce Delivery Performance & Customer Experience

## 1. Background & Business Context
In e-commerce, delivery reliability directly impacts customer retention and brand trust.  
This project analyzes 100k+ real orders from the Olist Brazilian marketplace to:
- Quantify how delivery delays affect customer satisfaction
- Identify whether sellers or logistics partners drive fulfillment failures
- Detect operational risk signals before negative reviews spike
- Provide actionable, operations-level recommendations

## 2.Dashboard Overview
This project is structured into two primary dashboards:
### Dashboard 1 – Customer Impact & Trend

<img width="988" height="787" alt="Screenshot 2026-02-19 at 14 12 22" src="https://github.com/user-attachments/assets/8ffae9f4-0725-47f9-a8ac-2843233d05a2" />

Focuses on how late deliveries affect customer satisfaction and overall performance metrics.
- Late Rate KPI
- Average Delay
- Review Score Impact Analysis
- Late Rate by Review Level

### Dashboard 2 – Operational Diagnosis

<img width="984" height="786" alt="Screenshot 2026-02-19 at 14 13 20" src="https://github.com/user-attachments/assets/a070c001-0a27-4a20-99c0-cc9344337304" />

Identifies operational drivers and risk concentration behind fulfillment failures.
- Carrier vs Seller Delay Attribution
- Delivery Component Comparison
- State-Level Risk Matrix
- High-Risk Time Period Identification

## 3. Business Questions:
1. **Satisfaction Correlation:** To what extent does delivery delay impact our average Review Scores?
2. **Bottleneck Diagnosis:** Is the delay caused by sellers (slow dispatch) or logistics partners (slow last-mile delivery)?
3. **Risk Distribution:** Which geographic regions or seller segments are the primary contributors to fulfillment failure?
4. **Risk Segmentation & Trend:** Where and when are late delivery risks concentrated?

## 4. Key Insights
### Key Performance

- **Late Rate:** 7.87%
- **Avg Carrier Time:** 9.28 days
- **Avg Delay (Late Only):** 10.62 days
- **Avg Seller Prep Time:** 2.71 days

Even a single-digit late rate translates into thousands of affected customers, making delay mitigation a high-impact operational priority.

### Delivery Delay Strongly Damages Customer Satisfaction
Late deliveries result in a **1.9-point drop** in review score:

| Delivery Status | Avg Review |
|-----------------|------------|
|   Late          | 2.271      |
|   On-time       | 4.212      |

**Insight:**  
Customer satisfaction drops sharply when delivery is late.
Delivery reliability directly influences reputation risk.

### Late Delivery Rate Decreases as Review Score Increases

<img width="517" height="723" alt="Screenshot 2026-02-19 at 13 54 11" src="https://github.com/user-attachments/assets/c7c7183e-0285-4cdb-802a-96bae23fbfc7" />

**Customer Ratings Reflect Delivery Risk**
Late delivery probability drops from 30% (1★ reviews) to under 2% (5★ reviews), demonstrating a strong negative correlation between logistics performance and customer satisfaction.

**Insight:**
Low ratings are strongly correlated with higher late delivery rates.
Logistics performance is a primary driver of customer dissatisfaction.

### Bottleneck Diagnosis: Carrier is the Primary Risk Driver

<img width="1050" height="250" alt="Screenshot 2026-02-19 at 13 58 02" src="https://github.com/user-attachments/assets/5711acfa-face-4cd9-a529-6ecf239a6b9e" />

Among late orders:
- ~80% are carrier-driven
- Seller-driven delays account for ~15–18%
- Mixed cases are minimal

**Insight:**  
- Last-mile logistics performance, rather than warehouse prep time, is the dominant contributor to late delivery.
- Operational focus should prioritize carrier management rather than seller SLAs.

### Delivery Component Comparison
**Insight:**
- Carrier time fluctuates significantly across months, while seller prep time remains relatively stable.
- This suggests that volatility in logistics networks contributes more heavily to delay risk than warehouse operations.

### Risk Concentration: State-Level Performance Matrix

<img width="889" height="717" alt="Screenshot 2026-02-19 at 13 56 34" src="https://github.com/user-attachments/assets/8ef23c57-6459-4d1f-b414-30412d359a31" />

**States vary significantly in:**
- Late rate
- Seller preparation time

**The matrix enables identification of:**
- High late-rate & high seller prep risk zones
- High late-rate but normal prep time → likely carrier-driven regions

**Operational Impact:**
- Targeted SLA renegotiation
- Tier-based traffic throttling
- Risk-weighted seller monitoring

### Time-Based Risk Concentration

<img width="388" height="725" alt="Screenshot 2026-02-19 at 13 59 43" src="https://github.com/user-attachments/assets/f0ebe5ae-4706-4e54-849b-c7f4c77ed4b7" />

**Insight:**
Certain months exhibit significantly higher late rates, indicating seasonal or capacity-driven logistics constraints.

## 5. Business Recommendations

### 1. Carrier-Focused Optimization Strategy
- Monitor carrier-driven delays
- Reallocate volume away from underperforming regions
### 2. Customer Impact Monitoring
- Track late rate alongside review score metrics
- Prevent reputation risk from compounding
### 3. State-Level Risk Governance
- Identify and intervene in high-risk geographic clusters
- Adjust SLA expectations regionally

## 6. Technical Implementation
**SQL (Primary Engine):**
- Order-level metric engineering
- Delay decomposition logic
- Bottleneck attribution
- Rolling window calculations
- Star schema modeling (fact + dimensions)

**Visualization:**
- Tableau Dashboards
- KPI monitoring
- Delay decomposition charts
- Risk segmentation matrix

Dataset: Brazilian E-Commerce Public Dataset by Olist (Kaggle)  
Time Range: 2016–2018  
Scale: 100k+ orders
