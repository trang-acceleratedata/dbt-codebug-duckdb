---
id: runbook-quarantine-mart
title: Quarantine a mart pending a durable fix (stop-gap)
engine-types: [dbt]
root-cause-patterns: [recurring data-quality failure, contract breach downstream impact, quarantine, stop-gap needed]
rate-limit: 3 per hour
auto-execute-eligible: true
runbook-class: mitigation
---

Temporary stop-gap for a recurring data-quality failure: quarantine the mart so
downstream consumers stop reading bad data, while a durable code fix is filed.
Does NOT fix the root cause — a mitigation, not a resolution.

## Preconditions
- `artifact-state` — `fct_opportunity` last run shows a data-quality test failure.

## Execution Steps
1. `write-quarantine-marker` — mark the mart quarantined: `mkdir -p .quarantine && printf 'fct_opportunity quarantined pending durable fix\n' > .quarantine/fct_opportunity`.

## Post-conditions
- `quarantine-in-place` — the marker exists: `test -f .quarantine/fct_opportunity`. Passes ⇒ the stop-gap is applied; outcome `auto-mitigated-pending-durable-fix`.

## Rollback Plan
- `remove-marker` — `rm -f .quarantine/fct_opportunity` to lift the quarantine. Non-destructive; only invoked on post-condition failure.
