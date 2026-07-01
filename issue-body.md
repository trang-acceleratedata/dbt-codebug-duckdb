<!-- vd-meta
engine: dbt
artifact: fct_opportunity
load_id: dbt-build-2026-07-01-0303
error_code: CAPACITY_EXHAUSTED
error_message: "Compute-capacity exhaustion: the fct_opportunity build was rejected by the platform with 'concurrency/quota limit exceeded' (429-class). Jobs are being queued/rejected at the compute ceiling — this is a capacity condition, not a logic or data fault."
severity: p2
-->

## Infra-capacity: `fct_opportunity` build rejected (compute quota / concurrency ceiling)

The build did not fail on logic or data — it was **rejected by the platform** for
exceeding the compute concurrency/quota ceiling (429-class "capacity limit
exceeded"). The warehouse/compute pool is saturated.

This is an **infrastructure-capacity** condition. The durable remedy is an
**operational capacity change** (raise the quota / scale the pool / stagger the
schedule) owned by the **platform/capacity team** — not a code change, and the
operate-agent has no tooling to resize platform capacity. Hand it off.
