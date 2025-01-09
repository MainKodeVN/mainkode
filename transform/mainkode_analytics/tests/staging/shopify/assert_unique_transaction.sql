SELECT
  id,
  COUNT(id)
FROM {{ ref('stg_shopify__transactions') }}
GROUP BY id
HAVING COUNT(id) > 1
