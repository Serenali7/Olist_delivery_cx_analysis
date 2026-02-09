-- =========================================
-- BI prepare 
SHOW COLUMNS FROM v_order_metrics_clean;
-- =========================================
-- dim_sellers
DROP TABLE IF EXISTS dim_sellers;

CREATE TABLE dim_sellers AS
SELECT 
    s.seller_id,
    s.seller_city,
    s.seller_state,
    g.lat,
    g.lng
FROM sellers s
LEFT JOIN (
    SELECT 
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS lat,
        AVG(geolocation_lng) AS lng
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
) g 
ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix;

-- =========================================
-- dim_products
DROP TABLE IF EXISTS dim_products;

CREATE TABLE dim_products AS
SELECT 
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    (product_weight_g IS NULL) AS is_weight_missing,
    (product_length_cm IS NULL) AS is_length_missing
FROM products;

-- =========================================
-- dim_calendar
DROP TABLE IF EXISTS dim_calendar;

SET SESSION cte_max_recursion_depth = 2000;

CREATE TABLE dim_calendar AS
WITH RECURSIVE days_cte AS (
    SELECT CAST('2016-01-01' AS DATE) AS d_date
    UNION ALL
    SELECT DATE_ADD(d_date, INTERVAL 1 DAY)
    FROM days_cte
    WHERE d_date < '2018-12-31'
)
SELECT 
    d_date AS `date`,
    YEAR(d_date) AS `year`,
    MONTH(d_date) AS `month`,
    QUARTER(d_date) AS `quarter`,
    DATE_FORMAT(d_date, '%Y-%m') AS `year_month`,
    DAYOFWEEK(d_date) AS `day_of_week`,
    DAYNAME(d_date) AS `day_name`
FROM days_cte;

-- =========================================
-- Fact Table
-- Step 0
-- 1) Identify fields containing empty strings
SELECT
  SUM(TRIM(order_purchase_timestamp) = '') AS bad_purchase_blank,
  SUM(TRIM(order_approved_at) = '') AS bad_approved_blank,
  SUM(TRIM(order_delivered_carrier_date) = '') AS bad_carrier_blank,
  SUM(TRIM(order_delivered_customer_date) = '') AS bad_customer_blank,
  SUM(TRIM(order_estimated_delivery_date) = '') AS bad_est_blank
FROM v_order_metrics_clean;

-- 2) Identify fields containing 0000-00-00 values
SELECT
  SUM(TRIM(order_purchase_timestamp) LIKE '0000-00-00%') AS bad_purchase_zero,
  SUM(TRIM(order_approved_at) LIKE '0000-00-00%') AS bad_approved_zero,
  SUM(TRIM(order_delivered_carrier_date) LIKE '0000-00-00%') AS bad_carrier_zero,
  SUM(TRIM(order_delivered_customer_date) LIKE '0000-00-00%') AS bad_customer_zero,
  SUM(TRIM(order_estimated_delivery_date) LIKE '0000-00-00%') AS bad_est_zero
FROM v_order_metrics_clean;

-- 3) Extract samples that are neither empty nor 0000-00-00 but still invalid
SELECT order_id, order_purchase_timestamp
FROM v_order_metrics_clean
WHERE TRIM(order_purchase_timestamp) <> ''
  AND TRIM(order_purchase_timestamp) NOT LIKE '0000-00-00%'
  AND STR_TO_DATE(TRIM(order_purchase_timestamp), '%Y-%m-%d %H:%i:%s') IS NULL
LIMIT 20;

-- Step 1 
DROP TABLE IF EXISTS fact_orders;

-- Rebuild the Fact Table
CREATE TABLE fact_orders AS 
SELECT 
    o.order_id,
    o.customer_id,
    oi.seller_id,
    oi.product_id,
    o.order_purchase_timestamp,
    -- Delivery Timeliness
    TIMESTAMPDIFF(HOUR, o.order_approved_at, o.order_delivered_carrier_date)/24.0 AS seller_prep_days,
    TIMESTAMPDIFF(HOUR, o.order_delivered_carrier_date, o.order_delivered_customer_date)/24.0 AS carrier_days,
    DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days,
    -- Status Indicators
    CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END AS is_late,
    -- Ratings and Monetary Values
    r.review_score,
    oi.price,
    oi.freight_value
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id 
LEFT JOIN order_reviews r ON o.order_id = r.order_id 
WHERE o.order_status = 'delivered' 
  AND o.order_delivered_customer_date IS NOT NULL;


-- ================================================
-- Test tables
SELECT COUNT(*) FROM dim_sellers;
SELECT COUNT(*) FROM dim_products;
SELECT COUNT(*) FROM dim_calendar;

SELECT * FROM dim_sellers LIMIT 5;
SELECT * FROM dim_products LIMIT 5;
SELECT * FROM dim_calendar LIMIT 5;
