<!-- vd-meta
engine: dbt
artifact: fct_opportunity
load_id: dbt-build-2026-06-12-0107
error_code: TRANSIENT_CONNECTION
error_message: "Read timed out while connecting to the DuckDB catalog: socket timeout after 30s (transient network error)"
severity: p2
-->

## Pipeline failure: `fct_opportunity` dbt build timed out

The scheduled dbt build for `fct_opportunity` failed with a transient connection
error (socket timeout reaching the warehouse catalog). No model or schema change
was deployed recently and the project compiles cleanly — this looks like a
transient network blip, not a logic or contract error.

Last run: `dbt-build-2026-06-12-0107` — status `error`,
`error_code TRANSIENT_CONNECTION`. See `target/run_results.json` in the
working tree (the model node carries the timeout message).
