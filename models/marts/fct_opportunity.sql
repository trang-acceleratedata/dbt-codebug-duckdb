-- Freshness-miss fixture (rollback-success case).
-- fct_opportunity carries a deliberately STALE load_date, so the
-- runbook-reload-stale-mart `freshness-restored` post-condition
-- (`count(*) where load_date >= current_date` > 0) fails even after a clean
-- rebuild — a genuinely stale source a rebuild cannot make fresh. That failing
-- post-condition drives the rollback (`git checkout -- .`, which succeeds here).
select
    opportunity_id,
    account_id,
    opportunity_name,
    stage_name,
    amount,
    close_date,
    is_won,
    case when is_won then amount else 0 end as won_amount,
    cast('2020-01-01' as date) as load_date
from {{ ref('stg_opportunities') }}
