WITH source AS (

  SELECT * FROM {{ source('shopify', 'shopify_fulfillments') }}

),

renamed AS (

  SELECT
    id,
    order_id,
    tracking_number,
    tracking_company

  FROM source

)

SELECT * FROM renamed
