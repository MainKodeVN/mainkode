-- Use the `ref` function to select from other models
select name
from {{ ref('my_first_dbt_model') }}
where id = 2