WITH fb_monthly_spend AS (
  SELECT
    EXTRACT(YEAR FROM date_stop)  AS ad_year,
    EXTRACT(MONTH FROM date_stop) AS ad_month,
    country,
    MAX(date_stop)                AS last_ad_date,
    SUM(spend)                    AS total_ad_spend
  FROM {{ ref('stg_facebook_ads__insights_country') }}
  GROUP BY 1, 2, 3
),

monthly_orders AS (
  SELECT
    EXTRACT(YEAR FROM created_at)  AS order_year,
    EXTRACT(MONTH FROM created_at) AS order_month,
    country_code,
    COUNT(DISTINCT id)             AS total_orders
  FROM {{ ref('int_orders_filtered') }}
  GROUP BY 1, 2, 3
),

orders_data AS (
  SELECT
    id                             AS order_id,
    created_at                     AS order_created_date,
    EXTRACT(YEAR FROM created_at)  AS order_year,
    EXTRACT(MONTH FROM created_at) AS order_month,
    country_code                   AS order_country_code
  FROM {{ ref('int_orders_filtered') }}
)

SELECT
  orders_data.order_id,
  orders_data.order_created_date,
  orders_data.order_year,
  orders_data.order_month,
  orders_data.order_country_code,
  fb_monthly_spend.total_ad_spend AS monthly_country_ad_spend,
  monthly_orders.total_orders     AS monthly_total_orders,
  CASE
    WHEN monthly_orders.total_orders = 0 THEN 0
    ELSE (fb_monthly_spend.total_ad_spend / monthly_orders.total_orders)
  END                             AS avg_ad_spend_per_order

FROM orders_data
LEFT JOIN fb_monthly_spend
  ON (
    orders_data.order_year = fb_monthly_spend.ad_year
    AND orders_data.order_month = fb_monthly_spend.ad_month
    AND orders_data.order_country_code = fb_monthly_spend.country
  )
LEFT JOIN monthly_orders
  ON (
    orders_data.order_year = monthly_orders.order_year
    AND orders_data.order_month = monthly_orders.order_month
    AND orders_data.order_country_code = monthly_orders.country_code
  )
