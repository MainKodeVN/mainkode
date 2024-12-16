WITH source AS (

  SELECT * FROM {{ source('shopify', 'shopify_balance_transactions') }}

),

renamed AS (

  SELECT
    id,
    source_order_id,
    fee,
    net,
    amount,
    type

  FROM source

)

SELECT * FROM renamed
