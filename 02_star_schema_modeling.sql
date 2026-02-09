-- =========================================
-- BI prepare 
SHOW COLUMNS FROM v_order_metrics_clean;
-- =========================================
-- dim_sellers
CREATE TABLE dim_sellers AS
SELECT 
    s.seller_id,
    s.seller_city,
    s.seller_state,
    g.geolocation_lat AS lat,
    g.geolocation_lng AS lng
FROM sellers s
LEFT JOIN (
    SELECT geolocation_zip_code_prefix, AVG(geolocation_lat) as geolocation_lat, AVG(geolocation_lng) as geolocation_lng
    FROM geolocation 
    GROUP BY 1
) g ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix;

-- =========================================
-- dim_products
CREATE TABLE dim_products AS
SELECT 
    product_id,
    product_category_name,
    COALESCE(product_weight_g, 0) AS product_weight_g,
    COALESCE(product_length_cm, 0) AS product_length_cm
FROM products;

-- =========================================
-- dim_calendar
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
    DAYOFWEEK(d_date) AS `day_of_week`
FROM days_cte;
