select
    id, count(id)
from {{ ref('stgs_shopify__transactions')}}
group by id
having count(id) > 1