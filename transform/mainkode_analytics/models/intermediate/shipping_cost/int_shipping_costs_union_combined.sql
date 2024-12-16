WITH
merged_shipping_services AS (
  SELECT
    ROUND(net_amount_euro, 2) AS shipping_costs,
    tracking_number,
    'FEDEX'                   AS shipping_service,
    recipient_country,
    proper_timestamp          AS cleaned_timestamp
  FROM {{ ref('stg_fedex__shipping_cost') }}

  UNION ALL

  SELECT
    total_net_ship_incl_pickup_amount_eur AS shipping_costs,
    cleaned_tracking_number               AS tracking_number,
    'SPRING'                              AS shipping_service,
    recipient_country,
    cleaned_timestamp
  FROM {{ ref('int_spring_costs_aggregated') }}
)

SELECT
  orders_filtered.id AS order_id,
  merged_shipping_services.shipping_costs,
  shopify_fulfillments.tracking_number,
  orders_filtered.country_code,
  merged_shipping_services.recipient_country,
  shopify_fulfillments.tracking_company
FROM {{ ref('int_orders_filtered') }} AS orders_filtered
LEFT JOIN {{ ref('stg_shopify__fulfillments') }} AS shopify_fulfillments ON orders_filtered.id = shopify_fulfillments.order_id
LEFT JOIN merged_shipping_services ON shopify_fulfillments.tracking_number = merged_shipping_services.tracking_number
