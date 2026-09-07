# D12 — Independent final regression (2026-09-06/07 UTC)

## 1. Final round

- Clean install of `rail_verdict-1.8.3.gem` (SHA `6ed0275c…`) into an empty
  gem home: `railverdict 1.8.3`, loads from the isolated path.
- `scripts/lab_run --all --artifact …`: **245/245 PASS, exit 0**, zero
  skipped/failed/blocked, on the final harness (oracle 2.1) and final
  candidate. ~30 min wall time.
- `lab_collect`: VALIDATION PASS, zero integrity errors, zero uncovered
  catalog capabilities.
- Trust-chain replay (RVLAB-01, DEEP-POL-001, DEEP-REPAIR-001,
  DEEP-REUSE-01, DEEP-MCP-001, DEEP-CI-UNMAP-11): 6/6 PASS, stable.
  The replays overwrote the single-run summary, so
  `lab-run-summary.json` was rebuilt deterministically from the 245
  per-scenario artifacts (script `/tmp/rebuild-summary.rb`, recorded
  here); all counts re-verified after rebuild.
- Lab suites on the final state: infrastructure 14/14, trust 26/26,
  oracle self-test 33/33. Product suite on the fix branch: 716 runs,
  0 failures (no product changes since).

## 2. Hygiene

No live locks remain; stray wrapper logs from the one BLOCKED run
removed (ignored `tmp/`). `artifacts/candidate-identity.json` now
records the 1.8.3 local build and is committed as the final identity.
