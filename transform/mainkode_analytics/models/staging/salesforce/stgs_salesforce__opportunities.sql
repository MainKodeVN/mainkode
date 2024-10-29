WITH source AS (

  SELECT * FROM {{ source('salesforce', 'opportunities') }}

),

renamed AS (

  SELECT
    opportunityid    AS opportunity_id,
    customerid       AS customer_id,
    opportunitystage AS opportunity_stage,
    closedate        AS close_date,
    expectedrevenue  AS expected_revenue,
    created_at,
    updated_at

  FROM source

)

SELECT * FROM renamed
