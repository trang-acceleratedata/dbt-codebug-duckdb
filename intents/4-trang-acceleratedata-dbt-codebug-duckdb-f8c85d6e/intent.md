# Intent

## Incident Summary

**Issue:** [dbt] DATA_QUALITY: `fct_opportunity.won_amount` non-zero for lost opportunities (run 4)
**Severity:** P2
**Load ID:** `dbt-build-2026-06-04-0051`
**Failing test:** `assert_won_amount_zero_when_not_won`
**Error:** 2 rows where `is_won = false` carry a non-zero `won_amount`

## Root Cause

`models/marts/fct_opportunity.sql` line 13 uses `amount as won_amount`, which assigns the raw deal amount to `won_amount` for **every row** regardless of outcome. Lost opportunities (where `is_won = false`) therefore report a non-zero `won_amount`, violating the business invariant.

Offending rows from `seeds/opportunity.csv`:

| opportunity_id | is_won | amount | won_amount (actual) | won_amount (expected) |
|---|---|---|---|---|
| 006B | false | 78000 | 78000 | 0 |
| 006D | false | 32000 | 32000 | 0 |

## Evidence

- `models/marts/fct_opportunity.sql:13` — `amount as won_amount` (unconditional)
- `tests/assert_won_amount_zero_when_not_won.sql` — returns rows where `not is_won and won_amount != 0`; returned 2 rows
- `seeds/opportunity.csv` — rows 006B and 006D have `is_won = false` with non-zero `amount`
- `target/run_results.json` — `unique_id: test.codebug.assert_won_amount_zero_when_not_won`, `status: fail`, `failures: 2`, `message: "Got 2 results, configured to fail if != 0"`

## Live Reproduction

`dbt build` run on 2026-06-08 confirms the failure is reproducible:

```
PASS=5 WARN=0 ERROR=1 SKIP=0 NO-OP=0 TOTAL=6

1 of 6  OK   seed file main.opportunity                          [INSERT 4]
2 of 6  OK   sql view model main.stg_opportunities               [OK]
3 of 6  OK   sql table model main.fct_opportunity                [OK]
4 of 6  PASS not_null_fct_opportunity_opportunity_id             [PASS]
5 of 6  PASS unique_fct_opportunity_opportunity_id               [PASS]
6 of 6  FAIL assert_won_amount_zero_when_not_won                 [FAIL 2]

Failure in test assert_won_amount_zero_when_not_won
  Got 2 results, configured to fail if != 0
```

The model builds successfully; only the data-quality test fails. This confirms the defect is purely in the `won_amount` expression in `fct_opportunity.sql` — not in upstream sources, seeds, or infrastructure. No runbook re-run will resolve it.

## Fix Required

Replace line 13 in `models/marts/fct_opportunity.sql`:

```sql
-- before (buggy)
amount as won_amount

-- after (correct)
case when is_won then amount else 0 end as won_amount
```
