select
    id, count(id)
from {{ ref('stgs_shopify__shopify_transactions')}}
group by id
having count(id) > 1