with validation as (
    select
        opportunityid,
        count(*) as count_id
    from {{ source('salesforce', 'opportunities') }}
    group by opportunityid
)

select *
from validation
where count_id > 1
