-- Freshness-miss fixture (rollback-success case).
-- load_date is a genuinely STALE value carried in the source seed (2024-01-15) —
-- it is DATA, not a hardcoded literal, so there is no code bug to "fix": the SQL
-- correctly passes the source's load_date through. runbook-reload-stale-mart
-- rebuilds the mart, but the freshness-restored post-condition
-- (`count(*) where load_date >= current_date` > 0) still returns 0 — a rebuild
-- cannot invent fresh source rows — so the rollback (`git checkout -- .`,
-- succeeds here) fires and the incident escalates.
select
    opportunity_id,
    account_id,
    opportunity_name,
    stage_name,
    amount,
    close_date,
    is_won,
    case when is_won then amount else 0 end as won_amount,
    load_date
from {{ ref('stg_opportunities') }}
