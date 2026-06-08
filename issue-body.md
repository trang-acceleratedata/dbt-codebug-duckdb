<!-- vd-meta
engine: dbt
artifact: fct_opportunity
load_id: dbt-build-2026-06-04-0051
error_code: DATA_QUALITY
error_message: "Singular test assert_won_amount_zero_when_not_won failed: 2 rows where a not-won opportunity has a non-zero won_amount"
severity: p2
-->

## Data-quality failure: `fct_opportunity.won_amount` non-zero for lost opportunities

The dbt build for `fct_opportunity` passed the model run but failed the singular
test `assert_won_amount_zero_when_not_won`: 2 opportunities with `is_won = false`
report a non-zero `won_amount`. This is a logic error in the model, not a
transient or infra failure — no runbook re-run will fix it; the model SQL must
change. See `target/run_results.json` (the failing test) and
`models/marts/fct_opportunity.sql` in the working tree.
