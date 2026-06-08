# Fixture: `dbt-codebug-duckdb`

A self-contained DuckDB dbt project carrying a **logic bug**: `fct_opportunity.won_amount`
is `amount` for every row, but must be `0` when `is_won = false`. The singular test
`tests/assert_won_amount_zero_when_not_won.sql` catches it (2 failing rows on the seed —
verified: `dbt build` → `FAIL 2`; the `case when is_won then amount else 0 end` fix → `PASS`).

Used by `packages/e2e-codefix-duckdb/` to probe whether the operate-agent can
hypothesize the cause and author + commit a working fix on the per-intent branch.
`setup.sh` git-inits the seeded workspace and checks out `op/codefix-probe`; the
agent's fix must land as a new commit on top. The correct fix is
`case when is_won then amount else 0 end as won_amount`.

## Contents
- dbt project code — `dbt_project.yml`, `profiles.yml` (duckdb, env-driven path),
  `seeds/opportunity.csv`, `models/staging/stg_opportunities.sql`,
  `models/marts/fct_opportunity.sql` (the bug), `models/marts/schema.yml`,
  `tests/assert_won_amount_zero_when_not_won.sql` (the catching test).
- collect/diagnose inputs — `target/run_results.json` (the failing test),
  `target/manifest.json` (compiled SQL + dep graph), `issue-body.md` (`vd-meta`).
- `runbooks/` — sample catalog; neither runbook matches a logic bug, so diagnose
  routes to `code-fix`.
