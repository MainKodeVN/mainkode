/*
Our intermediary refunds table is built from two sources:
1. `int_ecom_orders`: Contains e-commerce orders.
2. `stg_shopify_transactions`: Contains Shopify transaction data.

Logic:
- If a refund does not exist for an order, set the default refund value to `0`.
- If a refund exists, use the `amount` column (in EUR) to calculate the refund.
- Refunds are identified in the transactions table by:
  - `kind = 'REFUND'`
  - `status = 'SUCCESS'` or `status = 'PENDING'` (to include pending refunds).
*/
WITH order_tab AS (
  SELECT id AS order_id
  FROM {{ (ref('int_orders_filtered')) }}
),

refund_tab AS (
  SELECT
    id                  AS refund_id, -- Transaction ID for the refund
    order_id, -- Associated order ID
    kind, -- Type of transaction (e.g., REFUND)
    status, -- Status of the refund (e.g., SUCCESS, PENDING)
    COALESCE(amount, 0) AS refund_amount_eur, -- Store the cleaned refund amount
    created_at -- Timestamp of the refund transaction
  FROM {{ (ref('stg_shopify__transactions')) }}
  WHERE kind = 'REFUND' -- Filter for refund transactions
    AND (status = 'SUCCESS' OR status = 'PENDING') -- Include only successful or pending refunds
),

refund_orders AS (
  SELECT
    order_tab.order_id,
    COALESCE(refund_tab.refund_amount_eur, 0) AS refund_amount_eur -- Cleaned refund amount
  FROM order_tab
  LEFT JOIN refund_tab ON order_tab.order_id = refund_tab.order_id
)

SELECT
  order_id,
  SUM(refund_amount_eur) AS total_refund_amount_eur -- Calculate the total refund amount for each order
FROM refund_orders
GROUP BY 1 -- Group by order ID to aggregate refunds
