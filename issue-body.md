<!-- vd-meta
engine: dbt
artifact: fct_opportunity
load_id: dbt-build-2026-06-30-1115
error_code: DATA_QUALITY
error_message: "Recurring data-quality failure on fct_opportunity (won_amount); downstream consumers are reading bad rows. A stop-gap quarantine is warranted while a durable fix is prepared."
severity: p2
-->

## Recurring data-quality failure on `fct_opportunity`
This has fired repeatedly; downstream consumers are affected. Apply a stop-gap (quarantine) now and file the durable fix — do not wait for the code change to land.
