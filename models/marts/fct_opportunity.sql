-- Freshness-miss fixture (rollback-FAILED case).
-- load_date is a genuinely STALE value carried in the source seed (2024-01-15) —
-- DATA, not a code literal, so there is no code bug to "fix". The reload runbook
-- rebuilds the mart but freshness-restored still returns 0, triggering the
-- runbook's rollback step (`dbt run-operation restore_target_snapshot`) — a macro
-- that does NOT exist, so the rollback itself ERRORS: rollback-FAILED -> @DRE.
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
