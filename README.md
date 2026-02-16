# E-commerce Delivery Performance & Customer Experience

## 1. Background & Business Context
In e-commerce, delivery reliability directly impacts customer retention and brand trust.  
This project analyzes 100k+ real orders from the Olist Brazilian marketplace to:
- Quantify how delivery delays affect customer satisfaction
- Identify whether sellers or logistics partners drive fulfillment failures
- Detect operational risk signals before negative reviews spike
- Provide actionable, operations-level recommendations

## 2. Key Business Questions:
1. **Satisfaction Correlation:** To what extent does delivery delay impact our average Review Scores?
2. **Bottleneck Diagnosis:** Is the delay caused by sellers (slow dispatch) or logistics partners (slow last-mile delivery)?
3. **Risk Distribution:** Which geographic regions or seller segments are the primary contributors to fulfillment failure?
4. **Early Warning Signals:** How can we establish operational metrics to detect logistics risks before negative reviews spike?

# Key Performance

<img width="846" height="70" alt="Screenshot 2026-02-16 at 13 03 59" src="https://github.com/user-attachments/assets/03d290d9-cb80-4bdd-a990-19a440450b43" />

- **Late Rate:** 7.87%
- **Avg Carrier Time:** 9.28 days
- **Avg Delay (Late Only):** 10.62 days
- **Avg Seller Prep Time:** 2.71 days

Even a single-digit late rate translates into thousands of affected customers, making delay mitigation a high-impact operational priority.

# Delivery Delay Strongly Damages Customer Satisfaction

<img width="1012" height="721" alt="Screenshot 2026-02-16 at 13 23 37" src="https://github.com/user-attachments/assets/be992cc5-32ac-4cb5-a556-cd7fec61e5f7" />

Late deliveries result in a **1.73-point drop** in review score:

| Delivery Status | Avg Review |
|-----------------|------------|
| On-time         | 4.29       |
| Late            | 2.57       |

### Critical Threshold Identified
- 1–2 day delay → moderate dissatisfaction
- **3+ days delay → review collapse**
- 6+ days delay → ~70% of orders receive 1-star ratings

**Insight:**  
Preventing delays beyond 3 days dramatically reduces reputation damage.


# Bottleneck Diagnosis: Carrier is the Primary Risk Driver

<img width="853" height="713" alt="Screenshot 2026-02-16 at 13 24 08" src="https://github.com/user-attachments/assets/3f0ed14f-9436-49fc-a9e3-4c3a8e444c7d" />

Among late orders:
- Seller prep increases by ~2 days
- Carrier time increases by ~18 days
- 86% of late orders are carrier-driven

As delay severity rises, carrier time grows **non-linearly**, while seller prep time rises modestly.

**Insight:**  
Last-mile logistics, not warehouse prep, is the dominant operational bottleneck.


# Risk Concentration: Not All Sellers Are Equal

<img width="852" height="710" alt="Screenshot 2026-02-16 at 13 11 25" src="https://github.com/user-attachments/assets/d815b850-7f5c-49b6-86db-45097a1ce440" />

Late rate distribution across sellers is highly uneven.
A small subset of sellers contribute disproportionately to fulfillment failures.

**Operational Impact:**
- Targeted SLA renegotiation
- Tier-based traffic throttling
- Risk-weighted seller monitoring

This shifts operations from reactive complaint handling to proactive risk management.

# Early Warning Signal: Rolling 7-Day Late Rate
<img width="1015" height="713" alt="Screenshot 2026-02-16 at 13 10 07" src="https://github.com/user-attachments/assets/ba70eba1-b93a-48ed-a46f-be85f1e1dbba" />

Daily late rate is highly volatile.  
However, a 7-day rolling average provides a stable operational signal.
Spikes in rolling late rate consistently precede sustained delay waves.

**Business Value:**
- Acts as early logistics health indicator
- Enables proactive carrier intervention
- Prevents downstream review damage


# Business Recommendations

### 1. Redefine SLA Around 3-Day Threshold
Rather than optimizing averages, focus on preventing delays beyond 3 days.

### 2. Carrier-Focused Optimization Strategy
- Monitor carrier performance using rolling metrics
- Reallocate volume away from underperforming carriers
- Implement region-adjusted SLA thresholds

### 3. Tier-Based Seller Governance
- Intervene on high-risk sellers with sufficient order volume
- Reduce friction for consistently on-time sellers

### 4. Operationalize Rolling Late Rate
Embed rolling 7-day late rate into monitoring dashboards as an early warning metric.

# Technical Implementation
**SQL (Primary Engine):**
- Order-level metric engineering
- Delay decomposition logic
- Bottleneck attribution
- Rolling window calculations
- Star schema modeling (fact + dimensions)

**Visualization:**
- Tableau Dashboard
- KPI monitoring
- Delay decomposition charts
- Risk segmentation matrix

Dataset: Brazilian E-Commerce Public Dataset by Olist (Kaggle)  
Time Range: 2016–2018  
Scale: 100k+ orders
