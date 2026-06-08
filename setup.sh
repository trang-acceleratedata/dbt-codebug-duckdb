#!/usr/bin/env bash
# Make the seeded workspace a git repo on a per-intent branch, so the agent can
# commit its fix on top of a known "pinned" SHA (mirrors the harness's per-intent
# clone). Runs with WORKSPACE set by hooks/beforeEach.mjs.
set -euo pipefail
[ -n "${WORKSPACE:-}" ] || { echo "[setup] WORKSPACE not set" >&2; exit 1; }
cd "$WORKSPACE"
git init -q
git config user.email "eval@operate-agent.local"
git config user.name "operate-agent eval"
git config commit.gpgsign false
printf '.venv/\n*.duckdb\n*.duckdb.wal\ntarget/compiled/\ntarget/run/\nlogs/\n.opencode/\n.openhands/\n' > .gitignore
git add -A
git commit -q -m "seed: failing dbt-codebug fixture (won_amount bug)"
git checkout -q -b op/codefix-probe
echo "[setup] git repo on op/codefix-probe at $(git rev-parse --short HEAD)"
