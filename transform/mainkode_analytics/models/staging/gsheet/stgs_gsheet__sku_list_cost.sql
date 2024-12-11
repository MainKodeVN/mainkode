WITH source AS (

  SELECT * FROM {{ source('gsheet', 'gsheet_sku_list_cost') }}

),

renamed AS (

  SELECT
    _airbyte_raw_id,
    _airbyte_extracted_at,
    sku,
    CAST(cost AS NUMERIC) AS cost,
    name,
    size,
    year,
    category

  FROM source

)

SELECT * FROM renamed
