SELECT *
FROM {{ ref('stg_shopify__orders') }}
WHERE shipping_address IS NOT NULL -- If no shipping address then we assume it is a wholesale order.
