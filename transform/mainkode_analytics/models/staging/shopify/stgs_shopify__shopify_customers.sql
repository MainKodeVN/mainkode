WITH source AS (

  SELECT * FROM {{ source('shopify', 'shopify_customers') }}

),

renamed AS (

  SELECT
    id,
    first_name,
    last_name,
    email,
    created_at

  FROM source

)

SELECT * FROM renamed
