-- Save model as 'dbt_results.sql'

{{
  config(
    materialized = 'incremental',
    transient = False,
    unique_key = 'result_id'
  )
}}

WITH empty_table AS (
  SELECT
    NULL                AS result_id,
    NULL                AS invocation_id,
    NULL                AS unique_id,
    NULL                AS database_name,
    NULL                AS schema_name,
    NULL                AS table_name,
    NULL                AS resource_type,
    NULL                AS status,
    CAST(NULL AS FLOAT) AS execution_time,
    CAST(NULL AS INT)   AS rows_affected
)

SELECT * FROM empty_table
-- This is a filter so we will never actually insert these values
WHERE 1 = 0
