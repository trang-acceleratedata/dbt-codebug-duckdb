<!-- vd-meta
engine: dbt
artifact: fct_opportunity
load_id: dbt-build-2026-06-30-1101
error_code: FRESHNESS_MISS
error_message: "Freshness SLA breach: fct_opportunity has not refreshed within its window; the scheduled run appears skipped."
severity: p2
-->

## Freshness miss: `fct_opportunity` is stale
Missed its freshness SLA; last scheduled run landed no new rows. Looks like a skipped refresh (a reload should restore it), not a logic/schema change.
