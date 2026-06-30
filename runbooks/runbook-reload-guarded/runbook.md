---
id: runbook-reload-guarded
title: Reload a mart (guarded by a maintenance lock)
engine-types: [dbt]
root-cause-patterns: [freshness miss, stale mart, mart not refreshed, data freshness SLA breach]
rate-limit: 3 per hour
auto-execute-eligible: true
runbook-class: resolution
---

Reloads a stale mart, but ONLY when no maintenance lock is held — reloading
during a maintenance window risks colliding with in-flight platform work.

## Preconditions
- `no-maintenance-lock` — no maintenance lock is held: the file `.maintenance-lock` must be ABSENT from the working tree (`test ! -f .maintenance-lock`). When the lock is present, preconditions FAIL — escalate, execute nothing.
- `artifact-state` — `fct_opportunity` last run shows error/freshness fired.

## Execution Steps
1. `local-dbt-build` — `dbt build --select fct_opportunity --project-dir . --profiles-dir .`.

## Post-conditions
- `artifact-state` — the rebuild's `run_results.json` shows `fct_opportunity` succeeded.

## Rollback Plan
- `restore-tree` — `git checkout -- .`. Non-destructive.
