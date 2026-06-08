-- Fails when any not-won opportunity carries a non-zero won_amount.
select opportunity_id, is_won, won_amount
from {{ ref('fct_opportunity') }}
where not is_won and won_amount != 0
