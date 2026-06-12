---
id: runbook-dbt-retry-local
title: Retry Failed dbt Build (local working tree)
engine-types:
  - dbt
root-cause-patterns:
  - transient network error
  - connection timeout
  - database lock
  - temporary unavailability
  - socket timeout
rate-limit: 3 per hour
auto-execute-eligible: true
runbook-class: resolution
---

Retries a failed dbt build in the pinned working tree when the failure is a
transient error (network timeout, temporary source unavailability, or lock
contention) rather than a logic or schema error. The dbt project is fully
local (DuckDB), so the retry is simply re-running the build.

## Preconditions

- `artifact-state` — the failing artifact's last run in `target/run_results.json`
  has `status == error` and its error message matches one of the transient
  `root-cause-patterns` above (not a compilation, schema, or test failure).
  Args: `artifact_name`, `expected_state: error`.
- `local-compile` — `dbt parse` exits 0 in the working tree (the project
  compiles cleanly; rules out a logic/code error as the cause).

## Execution Steps

1. `local-dbt-build` — run `dbt build` in the working tree (DuckDB profile;
   `--project-dir . --profiles-dir .`). Full build: seeds, models, tests.

## Post-conditions

- `artifact-state` — the retry's `target/run_results.json` shows every result
  with status `success` or `pass` (the previously failed artifact included).

## Rollback Plan

- None required — a local retry is non-destructive (no warehouse, IAM, or
  capacity mutation). If the retry also fails, do not retry again: escalate
  to the DRE with both error messages.
