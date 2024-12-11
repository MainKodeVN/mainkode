WITH source AS (

  SELECT * FROM {{ source('fedex', 'shipping_fedex_shipping_cost') }}

),

renamed AS (

  SELECT
    _airbyte_raw_id,
    _airbyte_extracted_at,
    --_airbyte_meta,
    TO_DOUBLE(REPLACE(netchargeamountbilledcurrency, ',', '.')) AS net_amount_euro,
    --recipient_name,
    shipmenttrackingnumber                                      AS tracking_number,
    recipientcountry                                            AS recipient_country,
    servicedesc                                                 AS service_description,
    TO_TIMESTAMP(shipmentdate, 'MM/DD/YYYY')                    AS proper_timestamp
  FROM source


)

SELECT * FROM renamed
