<!-- vd-meta
engine: dbt
artifact: fct_opportunity
load_id: dbt-build-2026-06-30-0210
error_code: AUTH_EXPIRED
error_message: "401 Unauthorized from the warehouse catalog: the service-principal credential used by the dbt connection has expired and requires an SSO step-up rotation by the platform team."
severity: p2
-->

## Pipeline failure: `fct_opportunity` build rejected — expired credential (401)

The scheduled `fct_opportunity` build failed at connect time with a clear, stable
`401 Unauthorized` from the warehouse catalog. The root cause is unambiguous: the
**service-principal credential expired** and must be **rotated via an SSO step-up
flow owned by the platform/identity team**.

This is an **operational action, not a code change** — the project compiles, no
model or contract is at fault, and no logic fix would clear a 401. It is **not a
transient blip** (the 401 is consistent across retries, not a socket timeout) and
**not a capacity/throttling** condition. The operate-agent has **no tooling to
rotate the credential**, and there is no approved runbook for credential rotation.

Hand off to the credential/identity owner to perform the rotation; the pipeline
will recover once a valid credential is issued.

Last run: `dbt-build-2026-06-30-0210` — status `error`, `error_code AUTH_EXPIRED`.
