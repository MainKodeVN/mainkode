WITH order_manufacturing_costs AS (
  SELECT * FROM {{ ref('int_orderlines_joined_sku_costs') }}
)

SELECT
  MAX(order_id)                 AS order_id,
  SUM(total_manufacturing_cost) AS total_manufacturing_costs
FROM order_manufacturing_costs
GROUP BY order_id
