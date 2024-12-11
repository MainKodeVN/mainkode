WITH source AS (

  SELECT * FROM {{ source('gsheet', 'gsheet_eu_vat_rates') }}

),

renamed AS (

  SELECT
    _airbyte_raw_id,
    _airbyte_extracted_at,
    code                      AS country_code,
    year,
    CAST(vat_rate AS NUMERIC) AS vat_rate,
    member_states             AS member_state

  FROM source

)

SELECT * FROM renamed
