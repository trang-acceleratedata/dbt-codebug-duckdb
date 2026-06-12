-- BUG: won_amount must be 0 for opportunities that were not won.
-- This computes it as `amount` for every row, so lost opportunities carry a
-- non-zero won_amount. The singular test tests/assert_won_amount_zero_when_not_won.sql
-- catches it. Correct logic: case when is_won then amount else 0 end.
select
    opportunity_id,
    account_id,
    opportunity_name,
    stage_name,
    amount,
    close_date,
    is_won,
    case when is_won then amount else 0 end as won_amount
from {{ ref('stg_opportunities') }}
