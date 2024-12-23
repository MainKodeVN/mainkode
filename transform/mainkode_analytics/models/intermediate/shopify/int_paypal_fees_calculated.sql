WITH paypal_fees AS (
  SELECT
    id,
    order_id,
    gateway,
    status,
    amount,
    settle_amount,
    fee_amount_currency_id,
    exchange_rate,
    fee_amount_local_currency,
    created_at
  FROM {{ ref('stg_shopify__transactions') }}
),

orders AS (
  SELECT
    id,
    CASE
      WHEN gross_sales_lc = 0 THEN 1 -- If gross sales in local currency (gross_sales_lc) is 0, set the exchange rate to 1
      ELSE gross_sales_eur / gross_sales_lc -- Otherwise, calculate the exchange rate by dividing gross sales in EUR (gross_sales_eur) by gross sales in local currency (gross_sales_lc)
    END AS exchange_rate_from_orders
  FROM {{ ref('int_orders_filtered') }}
),

paypal_fees_from_orders AS (
  SELECT
    paypal_fees.order_id,
    orders.exchange_rate_from_orders,
    CASE
      WHEN paypal_fees.fee_amount_currency_id = 'EUR' THEN 1 -- If the fee amount is already in EUR, set the exchange rate to 1
      WHEN paypal_fees.fee_amount_currency_id <> 'EUR' AND paypal_fees.exchange_rate IS NOT NULL THEN paypal_fees.exchange_rate
      -- If the fee amount is in a foreign currency and PayPal provides an exchange rate, use PayPal's exchange rate
      WHEN paypal_fees.fee_amount_currency_id <> 'EUR' AND paypal_fees.exchange_rate IS NULL THEN orders.exchange_rate_from_orders
      -- If the fee amount is in a foreign currency but PayPal does not provide an exchange rate, use Shopify's 'exchange_rate_from_orders'
    END AS exchange_rate_cleaned
  FROM paypal_fees
  LEFT JOIN orders ON paypal_fees.order_id = orders.id
  WHERE paypal_fees.gateway = 'paypal'
    AND paypal_fees.status = 'SUCCESS'
    AND paypal_fees.fee_amount_currency_id <> 'EUR'
),

calc_paypal_fees AS (
  SELECT
    paypal_fees.id, -- The unique identifier for each PayPal transaction.
    {# kind, -- The type of transaction (e.g., SALE, CAPTURE). #}
    paypal_fees.gateway, -- The payment gateway used (in this case, PayPal).
    paypal_fees.status, -- The status of the transaction (e.g., SUCCESS).
    paypal_fees.order_id, -- The order ID associated with the transaction.
    paypal_fees.amount, -- The total revenue from the order as provided to the customer by Shopify, in EUR.
    paypal_fees.settle_amount, -- The net amount in EUR after deducting PayPal fees and currency conversion fees.
    paypal_fees.fee_amount_currency_id, -- The currency in which PayPal's fee was charged (e.g., USD, EUR).
    --fee_amount_local_currency, -- (Optional) The PayPal fee in local currency; commented out for now.
    --exchange_rate, -- (Optional) PayPal-provided exchange rate; commented out for now.
    paypal_fees_from_orders.exchange_rate_cleaned, -- The cleaned exchange rate determined earlier in the 'paypal_fees_from_orders' CTE.
    paypal_fees.created_at, -- The timestamp when the transaction occurred.

    -- Calculate the PayPal commission fee in EUR
    CASE
      WHEN paypal_fees_from_orders.exchange_rate_cleaned IS NULL AND paypal_fees.fee_amount_currency_id = 'EUR' THEN paypal_fees.fee_amount_local_currency
      -- If no exchange rate is provided and the fee is in EUR, use the local currency fee directly.

      WHEN paypal_fees_from_orders.exchange_rate_cleaned IS NOT NULL AND paypal_fees.fee_amount_currency_id = 'EUR' THEN paypal_fees.fee_amount_local_currency
      -- If an exchange rate is provided but the fee is already in EUR, use the local currency fee as is.

      WHEN paypal_fees_from_orders.exchange_rate_cleaned IS NOT NULL AND paypal_fees.fee_amount_currency_id <> 'EUR' THEN paypal_fees.fee_amount_local_currency * paypal_fees_from_orders.exchange_rate_cleaned
      -- If the fee is in a foreign currency, convert it to EUR using the cleaned exchange rate.
    END AS paypal_commision_fee_eur, -- Store the calculated commission fee as 'paypal_commision_fee_eur'.

    -- Calculate the PayPal conversion fee in EUR
    CASE
      WHEN paypal_fees.fee_amount_currency_id = 'EUR' THEN 0
      -- If the fee is already in EUR, there is no conversion fee.

      WHEN paypal_fees.fee_amount_currency_id <> 'EUR' AND paypal_fees.exchange_rate IS NULL THEN (0.0311 * paypal_fees.amount)
      -- If the fee is in a foreign currency and no exchange rate is available, assume a 3.11% conversion fee on the total amount.

      WHEN paypal_fees.fee_amount_currency_id <> 'EUR' AND paypal_fees.exchange_rate IS NOT NULL THEN (paypal_fees.amount - (paypal_fees.fee_amount_local_currency * paypal_fees_from_orders.exchange_rate_cleaned) - paypal_fees.settle_amount)
      -- If the fee is in a foreign currency and an exchange rate is provided, calculate the hidden conversion fee as:
      -- Total revenue (amount) minus the converted fee and the settled amount.
      -- Conversion Fee = Total Revenue (amount) - Converted Fee (fee_amount_local_currency * exchange_rate_cleaned) - Settled Amount (settle_amount)
    END AS paypal_conversion_fee_eur -- Store the calculated conversion fee as 'paypal_conversion_fee_eur'.
  FROM paypal_fees
  LEFT JOIN paypal_fees_from_orders
    ON paypal_fees.order_id = paypal_fees_from_orders.order_id
  WHERE paypal_fees.gateway = 'paypal' AND paypal_fees.status = 'SUCCESS'

)

SELECT
  *,
  paypal_commision_fee_eur + paypal_conversion_fee_eur AS total_paypal_fees_eur -- Add a new derived column 'total_paypal_fees_eur' by summing:
  -- 'paypal_commision_fee_eur': The PayPal commission fee in EUR, which includes transaction processing costs.
  -- 'paypal_conversion_fee_eur': The PayPal conversion fee in EUR, representing hidden costs associated with currency exchange.
  -- This column gives the total fees charged by PayPal for the transaction, including both commission and conversion fees.
FROM calc_paypal_fees
