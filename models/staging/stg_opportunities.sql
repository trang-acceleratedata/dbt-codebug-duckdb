select
    id          as opportunity_id,
    account_id,
    name        as opportunity_name,
    stage_name,
    amount,
    close_date,
    is_won,
    load_date
from {{ ref('opportunity') }}
