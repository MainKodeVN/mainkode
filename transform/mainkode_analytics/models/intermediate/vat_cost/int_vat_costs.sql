WITH order_tab AS (
  SELECT * FROM {{ (ref('int_orders_filtered')) }}
),

vat_tab AS (
  SELECT * FROM {{ (ref('stg_gsheet__eu_vat_rates')) }}
),

refund_orders AS (
  SELECT * FROM {{ (ref('int_refunds_calculated')) }}
)

SELECT
  order_tab.id AS order_id,
  order_tab.subtotal_price,
  order_tab.country_code,
  vat_tab.vat_rate,
  order_tab.gross_sales_eur,
  order_tab.gross_sales_lc,
  refund_orders.total_refund_amount_eur,
  CASE
    WHEN vat_tab.vat_rate IS NULL THEN 0
    WHEN vat_tab.vat_rate IS NOT NULL AND order_tab.country_code != 'GB' THEN ROUND(((vat_tab.vat_rate / (100 + vat_tab.vat_rate)) * (order_tab.gross_sales_eur - refund_orders.total_refund_amount_eur)), 2)
    WHEN vat_tab.vat_rate IS NOT NULL AND order_tab.country_code = 'GB' AND (order_tab.subtotal_price - refund_orders.total_refund_amount_eur) > (135 * (order_tab.gross_sales_eur / order_tab.gross_sales_lc)) THEN 0
    WHEN vat_tab.vat_rate IS NOT NULL AND order_tab.country_code = 'GB' AND (order_tab.subtotal_price - refund_orders.total_refund_amount_eur) < (135 * (order_tab.gross_sales_eur / order_tab.gross_sales_lc)) THEN ROUND(((vat_tab.vat_rate / (100 + vat_tab.vat_rate)) * (order_tab.subtotal_price - refund_orders.total_refund_amount_eur)), 2)
  END          AS vat_fee
FROM order_tab
LEFT JOIN vat_tab ON order_tab.country_code = vat_tab.country_code AND vat_tab.year = CAST(EXTRACT(YEAR FROM order_tab.created_at) AS STRING)
LEFT JOIN refund_orders ON order_tab.id = refund_orders.order_id
