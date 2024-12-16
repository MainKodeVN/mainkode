select
    id, count(id)
from {{ ref('stg_shopify__transactions')}}
group by id
having count(id) > 1