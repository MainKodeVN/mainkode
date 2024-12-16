/* Model to calculate Klarna commissions. Since all Klarna transactions are processed in EUR and the
   Airbyte connector for Klarna is deprecated, we rely on Shopify transaction data. Based on Klarna's settlement list:
   - Klarna's commission fee is €0.35 plus 5% of the gross sales amount.
*/

WITH klarna_fees AS (
  SELECT *
  FROM {{ ref('stg_shopify__transactions') }}
),

calc_klarna_fees AS (
  SELECT
    id, -- Unique transaction ID
    kind, -- Type of transaction (e.g., SALE, REFUND)
    gateway, -- Payment gateway (e.g., Klarna)
    status, -- Transaction status (e.g., SUCCESS)
    order_id, -- Associated order ID
    amount, -- Gross sales amount for the transaction in EUR
    created_at, -- Transaction timestamp
    0.35 + 0.05 * amount AS klarna_commision_fee_eur
  -- Calculate Klarna's commission fee as €0.35 base fee + 5% of the transaction amount
  FROM klarna_fees
  WHERE kind = 'SALE' AND gateway = 'Klarna' AND status = 'SUCCESS'

)

SELECT *
FROM calc_klarna_fees
