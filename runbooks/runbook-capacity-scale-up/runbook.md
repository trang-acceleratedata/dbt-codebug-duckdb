---
id: runbook-capacity-scale-up
title: Scale Up Fabric Capacity
engine-types:
  - dbt
  - dlt
  - capacity
root-cause-patterns:
  - capacity throttling
  - capacity exhaustion
  - utilization above 80
  - throttling active
  - sku exhaustion
  - capacity limit reached
rate-limit: 3 per 7 days
auto-execute-eligible: false
runbook-class: mitigation
---

Scales the Fabric capacity SKU up by one tier when sustained utilisation exceeds
80% and is causing pipeline failures or throttling. Migrated from
`vd-monitoring-agents/runbooks/runbook-capacity-scale-up.yaml`.

**`auto-execute-eligible: false` (advisory).** The core action — scaling the
Fabric capacity SKU — is NOT in the operate-agent's `fabric_rest_action` allowlist
(`resume_capacity`, `suspend_capacity`, `run_pipeline`, `cancel_pipeline_run`).
Until a `scale_capacity` action is added to that allowlist, this runbook is a
human-action / approval-gated proposal, not an auto-execute path. It is migrated
now to exercise the migration shape and the advisory case; see the Phase 2 plan's
"tool-allowlist gap" note. `runbook-class: mitigation` because scaling up stops the
throttling but leaves the over-provisioned workload intact (durable fix is a
permanent SKU change or workload redistribution).

## Preconditions

- `lakehouse-query` — `ops_capacity_metrics` shows `utilization_pct > 80` sustained
  over the last 30 minutes. Query `SELECT min(utilization_pct) FROM ops_capacity_metrics WHERE ts > dateadd(minute,-30,now())`,
  comparator `>`, expected `80`.
- `artifact-state` — the current capacity SKU is not already at the maximum tier.
  Args: `artifact_name: capacity`, `expected_state: below-max-tier`.

## Execution Steps

1. `azure_rest` (read-only) — confirm the current SKU tier and that no scheduled
   maintenance window is active.
2. **`scale_capacity` (advisory — not yet in the tool allowlist)** — scale the
   Fabric capacity up by one SKU tier. Until the tool exists this step is surfaced
   in an approval-gated proposal for a human to execute.
3. `azure_rest` (read-only) — after 5 minutes, confirm utilisation dropped below 70%.

## Post-conditions

- `lakehouse-query` — `ops_capacity_metrics` shows `utilization_pct < 70` within 10
  minutes. Comparator `<`, expected `70`.
- `pipeline_activity_query` — previously throttled pipelines resume execution.

## Rollback Plan

- Scale the capacity back down to the original tier (advisory, same tool gap).
- Alert the cost team if the scale-up is sustained beyond 24 hours, or if this
  runbook is proposed more than 3 times in 7 days — that indicates a permanent SKU
  upgrade or workload redistribution is the durable fix.
