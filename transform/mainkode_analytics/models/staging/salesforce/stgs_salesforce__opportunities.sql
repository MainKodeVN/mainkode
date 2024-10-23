WITH source AS (

  SELECT * FROM {{ source('salesforce', 'opportunities') }}

),

renamed AS (

  SELECT
    opportunityid,
    customerid,
    opportunitystage,
    closedate,
    expectedrevenue

  FROM source

)

SELECT * FROM renamed
