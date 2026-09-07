# D06 — Selection and reuse (candidate 1.8.3, 2026-09-06 UTC)

## 1. Legacy execution

test_selection 2/2 · mcp 15/15 on 1.8.3.

## 2. lib/ mapping regression (1.8.1), proven both frameworks

- DEEP-SEL-LIB-01 (RSpec): lib change with `spec/lib` candidate →
  `test_scope: targeted`, exactly 1 test, PASS, no crash.
- DEEP-SEL-LIB-02 (no candidate): same change without a spec →
  `test_scope: full` with explicit `fallback_reason:
  unmapped_source_change:lib/pricing.rb`, PASS, no crash.
- DEEP-SEL-LIB-03 (Minitest): `test/lib` candidate → targeted, 1 test, PASS.
- DEEP-SEL-SEM-01 (negative control): breaking lib behavior without updating
  the spec makes the targeted run FAIL — selection executes the mapped test,
  never a vacuous pass.
- Limitation on record: the mapper is convention-heuristic (see
  `test_candidates.rb`); TARGETED is not claimed equivalent to FULL.

## 3. Tiered reuse with subprocess proof (DEEP-REUSE-01, PASS)

A transparent `bundle` shim (`record_reuse`, logs PID/argv then delegates to
the real binary) counts subprocesses across a fresh check and a
handoff-backed check on the same state:

- fresh: rubocop_analysis 1, rspec_analysis 1 (+ version probes);
- reused: rubocop_analysis 0 (only probes), rspec_analysis 1;
- gates identical PASS; wrapper logs preserved per phase.

Version probes are classified separately from analysis runs. Two findings
along the way: the product scrubs subprocess env through `ENV_ALLOWLIST`
(good isolation — the log had to move to a PPID-keyed file outside the
worktree, since in-tree logs would trip the snapshot guard), and `handoff
create` mirrors the verification gate (exit 1 on FAIL), so the fixture must
be green. Wrapper fidelity: decisions with the shim active match shimless
runs (RVLAB-01 reference).

## 4. Obligations

O-SELECTION → covered. O-REUSE → covered with one carried edge:
advisory-DB-revision change between handoff and verify is untested
(bundler-audit DB dependence is contract, the transition lacks a scenario).
Catalog: 197 scenarios.
