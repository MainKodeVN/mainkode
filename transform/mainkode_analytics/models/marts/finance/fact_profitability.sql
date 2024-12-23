WITH order_tab AS (
  SELECT * FROM {{ ref('int_orders_filtered') }}
),

refund_tab AS (
  SELECT * FROM {{ ref('int_refunds_calculated') }}
),

vat_tab AS (
  SELECT * FROM {{ ref('int_vat_costs') }}
),

mktg_tab AS (
  SELECT * FROM {{ ref('int_paidmktg_avgcosts_per_order') }}
),

manuf_tab AS (
  SELECT * FROM {{ ref('int_orders_summed_manufacturing_costs') }}
),

shipping_tab AS (
  SELECT * FROM {{ ref('int_shipping_costs_union_combined') }}
),

commission_tab AS (
  SELECT * FROM {{ ref('int_orders_commission_fee_aggregated') }}
),

orderlineitems_tab AS ( --we aggregate in order to not have duplicate rows after our join as there are several line item rows per order
  SELECT
    id,
    SUM(quantity) AS total_quantity
  FROM {{ ref('int_orderlineitems_filtered') }}
  GROUP BY id
)


SELECT
  order_tab.*,
  refund_tab.total_refund_amount_eur,
  ROUND((order_tab.gross_sales_eur - COALESCE(refund_tab.total_refund_amount_eur, 0)), 2)                            AS gross_revenue_eur,
  vat_tab.vat_fee,
  ROUND((order_tab.gross_sales_eur - COALESCE(refund_tab.total_refund_amount_eur, 0) - vat_tab.vat_fee), 2)          AS net_revenue_eur,
  ROUND(COALESCE(mktg_tab.avg_ad_spend_per_order, 0), 2)                                                             AS marketing_cost,
  ROUND(manuf_tab.total_manufacturing_costs, 2)                                                                      AS manufacturing_cost,
  shipping_tab.shipping_costs,
  shipping_tab.tracking_number,
  commission_tab.total_commision_eur,
  ROUND((manuf_tab.total_manufacturing_costs + shipping_tab.shipping_costs + commission_tab.total_commision_eur), 2) AS cogs_eur,
  commission_tab.total_paypal_fees_eur,
  commission_tab.shopify_commission_fees_eur,
  commission_tab.klarna_commission_fees_eur,
  CASE
    WHEN shipping_tab.shipping_costs IS NULL AND order_tab.gross_sales_eur - COALESCE(refund_tab.total_refund_amount_eur, 0) < 20 THEN -ROUND(COALESCE(mktg_tab.avg_ad_spend_per_order, 0), 2)
    ELSE ROUND((order_tab.gross_sales_eur - COALESCE(refund_tab.total_refund_amount_eur, 0) - vat_tab.vat_fee - (COALESCE(mktg_tab.avg_ad_spend_per_order, 0) + manuf_tab.total_manufacturing_costs + shipping_tab.shipping_costs + commission_tab.total_commision_eur)), 2)
  END                                                                                                                AS gross_profit_eur


FROM order_tab
LEFT JOIN refund_tab ON order_tab.id = refund_tab.order_id
LEFT JOIN vat_tab ON order_tab.id = vat_tab.order_id
LEFT JOIN mktg_tab ON order_tab.id = mktg_tab.order_id
LEFT JOIN manuf_tab ON order_tab.id = manuf_tab.order_id
LEFT JOIN shipping_tab ON order_tab.id = shipping_tab.order_id
LEFT JOIN commission_tab ON order_tab.id = commission_tab.order_id
INNER JOIN orderlineitems_tab ON order_tab.id = orderlineitems_tab.id
