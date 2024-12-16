WITH cleaned_spring AS (
  SELECT * FROM {{ ref('stg_spring__shipping_cost') }}
),

agg_spring_costs AS (
  SELECT
    cleaned_tracking_number,
    SUM(net_amount_euro)                      AS total_net_shipping_amount_eur,
    MAX(recipient_country)                    AS recipient_country,
    MAX(service_description)                  AS service_description,
    MAX(proper_timestamp)                     AS cleaned_timestamp,
    MAX(EXTRACT(MONTH FROM proper_timestamp)) AS order_month,
    MAX(EXTRACT(YEAR FROM proper_timestamp))  AS order_year
  FROM cleaned_spring
  GROUP BY cleaned_tracking_number
),

count_order_month AS (
  SELECT
    COUNT(cleaned_tracking_number)       AS month_count_cl_track_number,
    EXTRACT(MONTH FROM proper_timestamp) AS order_month,
    EXTRACT(YEAR FROM proper_timestamp)  AS order_year
  FROM cleaned_spring
  WHERE service_description != 'PICK-UP'
  GROUP BY order_month, order_year
),

total_pickup_costs_month AS (
  SELECT
    SUM(net_amount_euro)                 AS month_total_pickup_costs,
    EXTRACT(MONTH FROM proper_timestamp) AS order_month,
    EXTRACT(YEAR FROM proper_timestamp)  AS order_year
  FROM cleaned_spring
  WHERE service_description = 'PICK-UP'
  GROUP BY order_month, order_year
)

SELECT
  agg_spring_costs.cleaned_tracking_number,
  agg_spring_costs.cleaned_timestamp,
  agg_spring_costs.order_month,
  agg_spring_costs.order_year,
  agg_spring_costs.recipient_country,
  agg_spring_costs.total_net_shipping_amount_eur,
  COALESCE(count_order_month.month_count_cl_track_number, 0)      AS month_count_cl_track_number,
  COALESCE(total_pickup_costs_month.month_total_pickup_costs, 0)  AS month_total_pickup_costs,
  COALESCE(
    total_pickup_costs_month.month_total_pickup_costs / count_order_month.month_count_cl_track_number,
    0
  ) + COALESCE(agg_spring_costs.total_net_shipping_amount_eur, 0)
    AS total_net_ship_incl_pickup_amount_eur
FROM agg_spring_costs
LEFT JOIN count_order_month
  ON agg_spring_costs.order_month = count_order_month.order_month
    AND agg_spring_costs.order_year = count_order_month.order_year
LEFT JOIN total_pickup_costs_month
  ON agg_spring_costs.order_month = total_pickup_costs_month.order_month
    AND agg_spring_costs.order_year = total_pickup_costs_month.order_year
