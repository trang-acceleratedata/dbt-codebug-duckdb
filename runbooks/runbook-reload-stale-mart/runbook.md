---
id: runbook-reload-stale-mart
title: Reload a stale mart (local dbt rebuild)
engine-types: [dbt]
root-cause-patterns: [freshness miss, stale mart, mart not refreshed, data freshness SLA breach]
rate-limit: 3 per hour
auto-execute-eligible: true
runbook-class: resolution
---

Rebuilds a mart whose freshness SLA was missed (assumed skipped refresh).
Non-destructive local dbt rebuild in the pinned working tree.

## Preconditions
- `artifact-state` — `fct_opportunity` last run shows error/freshness fired (`target/run_results.json`).

## Execution Steps
1. `local-dbt-build` — `dbt build --select fct_opportunity --project-dir . --profiles-dir .`.

## Post-conditions
- `freshness-restored` — `SELECT count(*) FROM fct_opportunity WHERE load_date >= current_date` returns `> 0`. Fails when the source is genuinely stale — a rebuild cannot invent fresh rows.

## Rollback Plan
- `restore-tree` — `git checkout -- .` to discard rebuild artifacts. Non-destructive; always succeeds.
