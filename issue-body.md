<!-- vd-meta
engine: dbt
artifact: fct_opportunity
load_id: dbt-build-2026-06-30-0042
error_code: UNKNOWN
error_message: "Worker process exited unexpectedly (signal 9) during fct_opportunity build; no stack trace, dbt log, or run_results node was captured for the failed invocation."
severity: p2
-->

## Pipeline failure: `fct_opportunity` build aborted (signal 9, no diagnostics)

The scheduled `fct_opportunity` build aborted mid-run: the worker process exited
with signal 9 and **no diagnostic output was captured** — no stack trace, no dbt
log lines for the node, and `target/run_results.json` has no entry for the failed
invocation. The project compiles cleanly and a manual rebuild **completes without
error**, so the failure is not reproducible from here.

It is not a connection timeout (no `TRANSIENT_CONNECTION`), there is no capacity
or throttling signal in the platform metrics, and no model, contract, or schema
change was deployed. With the evidence channels empty and no reproduction, the
root cause cannot be confidently determined from this incident alone.

Last run: `dbt-build-2026-06-30-0042` — status `error`, `error_code UNKNOWN`.
