---
id: runbook-dbt-retry
title: Retry Failed dbt Run
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

Retries a failed dbt run when the failure is a transient error (network timeout,
temporary source unavailability, or lock contention) rather than a logic error.
Migrated from `vd-monitoring-agents/runbooks/runbook-dbt-retry.yaml`; v1 actions
`trigger_pipeline` / `monitor_status` are re-pointed to the operate-agent tool
surface (`fabric_rest_action: run_pipeline`, `pipeline_activity_query`).

## Preconditions

- `artifact-state` — the failing dbt model's last run `status == error` and its
  `error_message` matches one of the transient `root-cause-patterns` above (not a
  model-compilation or schema error). Args: `artifact_name`, `expected_state: error`.
- `lakehouse-query` — no schema change was deployed in the last 24h.
  Query `SELECT count(*) FROM ops_schema_changes WHERE ts > dateadd(hour,-24,now())`,
  comparator `==`, expected `0`.

## Execution Steps

1. `fabric_rest_action: run_pipeline` (`confirm: true`) — re-trigger the Fabric
   pipeline that contains the failed dbt run (full run, do not wait for completion).
2. `pipeline_activity_query` — after 5 minutes, read the pipeline run status for
   the re-triggered run.

## Post-conditions

- `lakehouse-query` — `ops_dbt_runs` shows a new run row for the artifact since the
  trigger. Query `SELECT count(*) FROM ops_dbt_runs WHERE artifact = :artifact AND started_at > :trigger_ts`,
  comparator `>=`, expected `1`.
- `pipeline_activity_query` — the re-triggered run is `RUNNING` or `SUCCEEDED`
  within 10 minutes of the trigger.

## Rollback Plan

- None required — a retry is non-destructive (no warehouse, IAM, or capacity
  mutation occurs). If the retry also fails, do not retry again: escalate to the
  DRE with both run IDs and the captured error messages.
