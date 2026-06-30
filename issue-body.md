<!-- vd-meta
engine: dlt
artifact: src_salesforce.opportunity
load_id: 1718000000.01
error_code: AUTH_EXPIRED
error_message: "dlt extract failed: HTTP 401 Unauthorized from Salesforce — the API bearer token (dlt.secrets) was rejected. Two prior loads of this resource succeeded; only this run failed."
severity: p2
-->

## dlt ingestion failure: `src_salesforce.opportunity` (401 Unauthorized)

The Salesforce -> DuckDB **dlt** pipeline failed at extract with `HTTP 401`. The
bearer token configured in `dlt.secrets` was rejected — it looks expired/rotated.
The pipeline code and schema are unchanged and two prior loads succeeded.

This is an **operational credential rotation** (the Salesforce/identity owner must
issue a new token and update the secret) — not a code or schema change, and no
runbook covers credential rotation. See `dlt_pipeline/_dlt_loads.csv` for the
failed load record.
