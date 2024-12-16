WITH source AS (

  SELECT * FROM {{ source('shopify', 'shopify_products') }}

),

renamed AS (

  SELECT
    _airbyte_raw_id,
    _airbyte_extracted_at,
    id,
    tags,
    title,
    handle,
    status,
    options,
    created_at,
    deleted_at,
    updated_at,
    product_type,
    published_at,
    published_scope,
    template_suffix

  FROM source

)

SELECT * FROM renamed
