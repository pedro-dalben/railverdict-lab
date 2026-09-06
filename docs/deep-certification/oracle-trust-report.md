# D02 — Harness trust report (2026-09-06 UTC)

Machine-readable verdict: `oracle-trust-report.json` (this directory).
Oracle version `2.1.0`. Suite: `lab_infrastructure_test` 13/13,
`lab_oracle_trust_test` 21/21, oracle `--self-test` 20/20 checks.
All 10 mandatory mutants killed; no equivalent mutants claimed.

## 1. Harness defects confirmed by reproduction (not just inspection)

| # | Defect | Proof |
|---|---|---|
| H-01 | Oracle skipped any expectation whose key was absent from the result (`lab_oracle:144-146`), so a missing property certified instead of failing. | `introduced_min` against a result without counts/findings passed the old code path; now FAILs with `unevaluated:missing_counts`. |
| H-02 | Missing counts degraded to zeros derived from nothing; `introduced_max: 0` passed on empty evidence. | Empty `{}` against RVLAB-01 now FAILs. |
| H-03 | `quality_delta_available: false` matched a missing `quality_delta`. | Now `unevaluated:missing_quality_delta` → FAIL. |
| H-04 | `LabSupport.json` collapsed every parse error to `{}`. | `json_strict` raises; cli/cli_sarif record `lab_error` and judge FAIL. |
| H-05 | `config_replace` with a non-matching `from` silently did nothing; `bundle lock --remove` status ignored. | Both raise before measurement (unit-tested). |
| H-06 | `clone_fixture(..., branch:)` creates a nominal branch from campaign HEAD instead of checking out the fixture branch of the same name. | Read-only finding from D00 kept as specified behavior; fixture truth now comes from recorded `fixture_before`/`fixture_after` identity, not the branch name. |
| H-07 | Runner reused `tmp/scenario-<id>` and deleted `artifacts/<id>` per attempt: retries overwrote evidence, concurrent runs collided. | PID-suffixed workdirs, mutual-exclusion locks, previous attempts moved to `artifacts/<id>.attempts/<ts>-pid<PID>/`. |
| H-08 | `oracle.json` captured oracle stdout, which mixed a JSON document with a human verdict line (multi-document file). | Oracle stdout is now exactly one JSON document; runner validates it parses. |
| H-09 | Harness errors (unknown scenario, missing/truncated result) exited 1, indistinguishable from verdict FAIL. | Harness errors exit 2; verdict FAIL exits 1; install failure writes a BLOCKED summary and exits 2. |
| H-10 | `candidate.yml` declared `source_sha: HEAD`, violating the lab's own `test_candidate_is_an_exact_published_package_contract` (red baseline). | Pinned to `89a46733b0daa3cfd921dfe428407a416f3fd709`; suite back to 13/13. |
| H-11 | Empty selection aborted vaguely; all-skipped and empty aggregation reported success-shaped output. | Explicit refusals: runner exit 2 on empty selection and all-skipped; collect exit 2 on empty rows or uncovered capabilities. |
| H-12 | No per-step timeout existed; a hung analyzer hung the campaign. | `timeout -k 5 <n>` envelope via `timeout_seconds`; exit 124 sets `lab_timeout` with partial logs preserved. |

## 2. What the oracle guarantees now

- Every declared expectation yields exactly one check: `declared_assertions`,
  `evaluated_assertions`, `failed_assertions`, `unconsumed_assertions` are
  recorded on each observation. An expectation that cannot be evaluated
  (missing key, null expectation, typo'd name) fails the scenario.
- Strict type families: `false`, `0`, `nil`, `[]`, `{}` never match each other;
  numerics compare only against numerics. Check rows carry both type tags.
- Evidence provenance on counts: `stated` vs `derived` (from present findings)
  vs `missing`. Nothing is inferred from absent evidence; the old `readiness`
  → completion inference is removed.
- Missing-vs-empty is explicit for `analyzer_results`, `decision_reasons`,
  `requirements`, `observations`, `review_focus`, and `quality_delta`.

## 3. Aggregation guarantees

- Rows with missing observations, scenario-ID mismatch, runner-PASS detached
  from observation, or passing observations with unconsumed assertions are
  rejected (BLOCKED/FAIL), and the markdown report names them.
- Catalog-declared capabilities (`capability:`) with zero executed scenarios
  force `VALIDATION INCOMPLETE` (exit 2). Full capability×scenario mapping
  lands in D03 (`coverage-obligations.json`).
- `LAB_ROOT` override makes aggregation testable without touching the repo.

## 4. Residual limitations (carried, not hidden)

- `timeout` kills the direct child; grandchild analyzer reaping is unproven.
- `cli_sarif` envelopes carry a lab-synthesized gate by interface design,
  now labeled `lab_synthesized_gate: true`.
- The lock is mutual exclusion, not parallel execution.
- Legacy `VALIDATION_REPORT.md` template lines (capability-gating notes)
  refresh in D12.

## 5. Files changed

`scripts/lab_oracle` (rewrite of `evaluate`, driver discipline, self-test
battery), `scripts/lab_run` (locks, attempts, strict parse, fixture identity,
timeouts, exit taxonomy), `scripts/lab_support.rb` (`json_strict`,
timeout-aware `product_run`, setup guards, `fixture_identity`, lock protocol),
`scripts/lab_collect` (integrity, capabilities, empty-refusal, exit taxonomy),
`lab/candidate.yml` (`source_sha` pin), `test/unit/lab_oracle_trust_test.rb`
(new, 21 tests mapping LAB-01…LAB-15 plus the 10 mandatory mutants).
