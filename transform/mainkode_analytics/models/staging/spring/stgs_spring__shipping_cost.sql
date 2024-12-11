WITH source AS (

  SELECT * FROM {{ source('spring', 'shipping_spring_shipping') }}

),

renamed AS (

  SELECT
    _airbyte_raw_id,
    _airbyte_extracted_at,
    _airbyte_meta,
    CAST(REPLACE(net_amount_euro, ',', '.') AS DECIMAL)             AS net_amount_euro,
    tracking_number,
    CASE
      WHEN tracking_number LIKE '%/%' THEN REGEXP_SUBSTR(tracking_number, '^(.*?)/')
      ELSE tracking_number
    END                                                             AS cleaned_tracking_number,
    recipient_country,
    service_description,
    TO_TIMESTAMP(shipment_date_dd_mm_yyyy, 'DD/MM/YYYY HH24.MI.SS') AS proper_timestamp

  FROM source

)

SELECT * FROM renamed
