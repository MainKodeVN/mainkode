WITH calc_shop_fees AS (
  SELECT
    id,
    source_order_id AS order_id,
    type,
    fee             AS shopify_commission_fees_eur, -- The Shopify commission fee for the transaction.
    amount          AS amount_eur, -- The total revenue (gross amount) for the order.
    net             AS net_revenue_after_shop_fees_eur -- The remaining revenue after Shopify's commission fee is deducted.
  FROM {{ ref('stg_shopify__balance_transactions') }}
  WHERE type = 'charge'
  {#
    type: Indicates the type of transaction:
        - charge: A payment made by a customer.
        - refund: A refund issued to the customer (negative amounts for fee, net, and amount).
        - payout: A bulk payout made by Shopify to the merchant (aggregates multiple transactions).
  #}
)

SELECT *
FROM calc_shop_fees
