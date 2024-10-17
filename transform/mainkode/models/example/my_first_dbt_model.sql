/*
    Welcome to your first dbt model!
    This model creates a view with mock data, excludes records with null `id` values, and adds a new column.
*/

{{ config(materialized='table') }}

with source_data as (

    select 1 as id, 'Alice' as name
    union all
    select 2 as id, 'Bob' as name
    union all
    select 3 as id, 'Charlie' as name
    union all
    select null as id, 'David' as name
    union all
    select 4 as id, null as name

)

select
    id,
    name
from source_data

