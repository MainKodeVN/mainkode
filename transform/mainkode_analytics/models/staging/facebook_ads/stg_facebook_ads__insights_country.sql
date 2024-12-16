WITH source AS (

  SELECT * FROM {{ source('facebook_ads', 'facebook_ads_insights_country') }}

),

renamed AS (

  SELECT
    _airbyte_raw_id,
    _airbyte_extracted_at,
    cpc,
    cpm,
    cpp,
    ctr,
    ad_id,
    reach,
    spend,
    clicks,
    ad_name,
    country,
    TO_TIMESTAMP(date_stop) AS date_stop,
    created_time,
    cost_per_unique_click
  FROM source
  WHERE LOWER(ad_name) NOT LIKE '%instagram%'
)

SELECT * FROM renamed
