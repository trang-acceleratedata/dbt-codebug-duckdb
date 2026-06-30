---
id: runbook-reload-stale-mart
title: Reload a stale mart (clears target first)
engine-types: [dbt]
root-cause-patterns: [freshness miss, stale mart, mart not refreshed, data freshness SLA breach]
rate-limit: 3 per hour
auto-execute-eligible: true
runbook-class: resolution
---

Rebuilds a stale mart after clearing compiled target. The rollback step is
deliberately broken in this fixture to exercise the rollback-FAILURE path.

## Preconditions
- `artifact-state` — `fct_opportunity` last run shows error/freshness fired.

## Execution Steps
1. `clear-target` — `rm -rf target/compiled target/run`.
2. `local-dbt-build` — `dbt build --select fct_opportunity --project-dir . --profiles-dir .`.

## Post-conditions
- `freshness-restored` — `SELECT count(*) FROM fct_opportunity WHERE load_date >= current_date` returns `> 0`. Fails — source is stale.

## Rollback Plan
- `restore-from-snapshot` — `dbt run-operation restore_target_snapshot`. This macro does NOT exist in the project, so the rollback step ERRORS — exercising the rollback-failed -> @-mention DRE path.
