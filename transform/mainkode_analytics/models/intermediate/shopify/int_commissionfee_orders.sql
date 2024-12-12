-- Here we add together the fees for each order from all our gateways, including Shopify, PayPal, and Klarna.

WITH paypal_fee AS (
  SELECT *
  FROM {{ ref('int_paypal_fees_from_shop_transactions') }}
),

shop_fee AS (
  SELECT *
  FROM {{ ref('int_shop_fees_from_shop_transactions') }}
),

klarna_fee AS (
  SELECT *
  FROM {{ ref('int_klarna_fees_from_shop_transactions') }}
)

SELECT
  COALESCE(shop_fee.order_id, paypal_fee.order_id, klarna_fee.order_id)                                                                                AS order_id, -- Use COALESCE to get the first non-null order ID from Shopify, PayPal, or Klarna
  COALESCE(paypal_fee.total_paypal_fees_eur, 0)                                                                                                        AS total_paypal_fees_eur, -- Set PayPal fees to 0 if no record exists for the order
  COALESCE(shop_fee.shopify_commission_fees_eur, 0)                                                                                                    AS shopify_commission_fees_eur, -- Set Shopify fees to 0 if no record exists for the order
  COALESCE(klarna_fee.klarna_commision_fee_eur, 0)                                                                                                     AS klarna_commission_fees_eur, -- Set Klarna fees to 0 if no record exists for the order
  COALESCE(paypal_fee.total_paypal_fees_eur, 0) + COALESCE(shop_fee.shopify_commission_fees_eur, 0) + COALESCE(klarna_fee.klarna_commision_fee_eur, 0) AS total_commision_eur
-- Calculate the total commission fees by summing PayPal, Shopify, and Klarna fees (handling null values with IFNULL)
FROM paypal_fee
FULL OUTER JOIN shop_fee ON paypal_fee.order_id = shop_fee.order_id -- Perform a FULL OUTER JOIN to include all orders, even if they are missing from one or more gateways
FULL OUTER JOIN klarna_fee ON shop_fee.order_id = klarna_fee.order_id -- Join Klarna fees on Shopify order ID to consolidate data from all gateways
