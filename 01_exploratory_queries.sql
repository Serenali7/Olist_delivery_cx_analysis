-- =================================================
-- 01_create_views
-- Purpose: Build clean order-level metric views

-- Aggregate order_items to order level
CREATE OR REPLACE VIEW v_order_items_agg AS
SELECT
  order_id,
  MIN(shipping_limit_date) AS shipping_limit_date,
  COUNT(*) AS item_cnt,
  SUM(price) AS item_price_sum,
  SUM(freight_value) AS freight_sum,
  COUNT(DISTINCT seller_id) AS seller_cnt
FROM order_items
GROUP BY order_id;

-- Build core order-level metrics view
CREATE OR REPLACE VIEW v_order_metrics AS
SELECT
  o.order_id,
  o.customer_id,
  o.order_status,
  o.order_purchase_timestamp,
  o.order_approved_at,
  o.order_delivered_carrier_date,
  o.order_delivered_customer_date,
  o.order_estimated_delivery_date,
  r.review_score,
  a.item_cnt,
  a.item_price_sum,
  a.freight_sum,
  a.seller_cnt,
  -- Lead time decomposition (days)
  TIMESTAMPDIFF(HOUR, o.order_approved_at, o.order_delivered_carrier_date)/24.0 AS seller_prep_time_days,
  TIMESTAMPDIFF(HOUR, o.order_delivered_carrier_date, o.order_delivered_customer_date)/24.0 AS carrier_lead_time_days,

  -- Delay flags
  CASE
    WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1
    ELSE 0
  END AS is_late,
  DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
FROM orders o
LEFT JOIN v_order_items_agg a ON o.order_id = a.order_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id;


-- Clean analysis view
CREATE OR REPLACE VIEW v_order_metrics_clean AS
SELECT *
FROM v_order_metrics
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
  
  -- ================================================
-- 02_satisfaction_impact
-- Purpose: Measure delay impact on review scores

-- Review score gap (on-time vs late)
SELECT
  AVG(CASE WHEN is_late = 0 THEN review_score END) AS avg_on_time_score,
  AVG(CASE WHEN is_late = 1 THEN review_score END) AS avg_late_score,
  AVG(CASE WHEN is_late = 0 THEN review_score END)
  - AVG(CASE WHEN is_late = 1 THEN review_score END) AS score_gap
FROM v_order_metrics_clean
WHERE review_score IS NOT NULL;

-- Delay bucket analysis
SELECT
  CASE
    WHEN delay_days <= 0 THEN 'on_time_or_early'
    WHEN delay_days BETWEEN 1 AND 2 THEN 'late_1_2'
    WHEN delay_days BETWEEN 3 AND 5 THEN 'late_3_5'
    WHEN delay_days BETWEEN 6 AND 10 THEN 'late_6_10'
    ELSE 'late_10_plus'
  END AS delay_bucket,
  COUNT(*) AS orders,
  AVG(review_score) AS avg_score,
  AVG(review_score = 1) AS pct_1_star
FROM v_order_metrics_clean
WHERE review_score IS NOT NULL
GROUP BY delay_bucket;

-- =========================================
-- 03_bottleneck_analysis
-- Purpose: Diagnose seller vs carrier bottlenecks

-- 03-01 Build delay decomposition at order level
CREATE OR REPLACE VIEW v_order_delay_decomp AS
SELECT
    o.order_id,

    -- Late flag
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 1 ELSE 0 
    END AS is_late,

    -- Total delay days
    GREATEST(
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date),
        0
    ) AS delay_days,

    -- Seller prep time (approval → carrier)
    DATEDIFF(
        o.order_delivered_carrier_date,
        o.order_approved_at
    ) AS seller_prep_days,

    -- Carrier / last-mile time
    DATEDIFF(
        o.order_delivered_customer_date,
        o.order_delivered_carrier_date
    ) AS carrier_days

FROM orders o
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_delivered_carrier_date IS NOT NULL
  AND o.order_approved_at IS NOT NULL;

-- 03-02 Avg delay contribution among late orders
SELECT
    AVG(seller_prep_days) AS avg_seller_prep_days,
    AVG(carrier_days) AS avg_carrier_days,
    AVG(delay_days) AS avg_total_delay_days
FROM v_order_delay_decomp
WHERE is_late = 1;

-- 03-03 Delay bucket vs seller / carrier contribution
SELECT
    CASE
        WHEN delay_days = 0 THEN 'on_time'
        WHEN delay_days BETWEEN 1 AND 2 THEN 'late_1_2'
        WHEN delay_days BETWEEN 3 AND 5 THEN 'late_3_5'
        WHEN delay_days BETWEEN 6 AND 10 THEN 'late_6_10'
        ELSE 'late_10_plus'
    END AS delay_bucket,
    COUNT(*) AS orders,
    AVG(seller_prep_days) AS avg_seller_prep_days,
    AVG(carrier_days) AS avg_carrier_days
FROM v_order_delay_decomp
WHERE is_late = 1
GROUP BY delay_bucket
ORDER BY delay_bucket;

-- 03-04 Bottleneck classification
SELECT
    CASE
        WHEN seller_prep_days >= carrier_days THEN 'seller_driven'
        ELSE 'carrier_driven'
    END AS delay_driver,
    COUNT(*) AS orders,
    ROUND(COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (), 4) AS pct_orders
FROM v_order_delay_decomp
WHERE is_late = 1
GROUP BY delay_driver;

-- =========================================
-- 04_risk_segmentation
-- Purpose: Identify risky sellers and regions

-- Seller performance tiering
SELECT
  oi.seller_id,
  COUNT(*) AS orders,
  AVG(om.is_late) AS late_rate
FROM v_order_metrics_clean om
JOIN order_items oi ON om.order_id = oi.order_id
GROUP BY oi.seller_id
ORDER BY orders DESC
LIMIT 20;

-- Seller Order Volume Distribution
SELECT
  COUNT(*) AS sellers,
  MIN(cnt) AS min_orders,
  MAX(cnt) AS max_orders,
  AVG(cnt) AS avg_orders
FROM (
  SELECT oi.seller_id, COUNT(*) cnt
  FROM v_order_metrics_clean om
  JOIN order_items oi ON om.order_id = oi.order_id
  GROUP BY oi.seller_id
) t;

-- Overall distribution of seller late_rate
SELECT
  ROUND(late_rate, 2) AS late_rate_bucket,
  COUNT(*) sellers
FROM (
  SELECT oi.seller_id, AVG(om.is_late) AS late_rate
  FROM v_order_metrics_clean om
  JOIN order_items oi ON om.order_id = oi.order_id
  GROUP BY oi.seller_id
) t
GROUP BY ROUND(late_rate, 2)
ORDER BY late_rate_bucket;


-- =========================================
-- 05_early_warning
-- Purpose: Rolling late rate for early risk detection

SELECT
  DATE(order_purchase_timestamp) AS order_date,
  AVG(is_late) AS daily_late_rate,
  AVG(AVG(is_late)) OVER (
    ORDER BY DATE(order_purchase_timestamp)
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS rolling_7d_late_rate
FROM v_order_metrics_clean
GROUP BY order_date
ORDER BY order_date;
