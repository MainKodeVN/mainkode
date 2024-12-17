WITH order_lines AS (
  SELECT * FROM {{ ref('int_orderlineitems_filtered') }}
),

sku_costs AS (
  SELECT * FROM {{ ref('stg_gsheet__sku_list_cost') }}
)

SELECT
  order_lines.id                          AS order_id,
  sku_costs.sku,
  sku_costs.year,
  sku_costs.cost                          AS item_unit_cost,
  order_lines.created_at,
  order_lines.quantity,
  (order_lines.quantity * sku_costs.cost) AS total_manufacturing_cost
FROM order_lines
LEFT JOIN sku_costs ON (order_lines.sku = sku_costs.sku AND EXTRACT(YEAR FROM order_lines.created_at) = CAST(sku_costs.year AS BIGINT))
