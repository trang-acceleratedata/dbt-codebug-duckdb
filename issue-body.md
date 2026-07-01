<!-- vd-meta
engine: dbt
artifact: fct_opportunity
load_id: dbt-build-2026-07-01-0303
error_code: CAPACITY_THROTTLED
error_message: "Fabric capacity throttling: the fct_opportunity build was rejected with HTTP 429 TooManyRequests / 'capacity limit exceeded'. The capacity (F-SKU) is at its ceiling; jobs are being queued/rejected, not failing on logic."
severity: p2
-->

## Infra-capacity: `fct_opportunity` build throttled (429, capacity at ceiling)

The build did not fail on logic or data — it was **rejected by the platform**:
repeated `429 TooManyRequests` with "capacity limit exceeded". The Fabric
capacity is saturated (concurrent jobs at the F-SKU ceiling).

This is an **infrastructure-capacity** condition. The durable remedy is an
**operational capacity change** (scale the SKU / stagger the schedule / raise the
limit) owned by the **platform/capacity team** — not a code change, and the
operate-agent has no tooling to resize Fabric capacity. Hand it off.
