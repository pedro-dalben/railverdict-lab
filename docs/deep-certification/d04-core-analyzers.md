# D04 — Core and analyzers (candidate 1.8.3, 2026-09-06 UTC)

## 1. Product defects found and fixed in this node

B-001 (dead `investigate` dispatch) and B-002 (`--format sarif` silently
rendering console): reproduced on locked 1.8.2, fixed minimally on product
branch `fix/1.8.3-cli-surface` (`8e41472`, CLI surface only), negative-
controlled by product regression tests, verified on isolated 1.8.3 install,
full product suite 716 runs / 0 failures / 5 skips. Details: `defects.md`;
new candidate: `candidate-1.8.3.lock.json`. All D04 evidence below belongs
to 1.8.3 unless labeled 1.8.2-discovery.

## 2. Harness defects found while executing

- H-13: `remove_dependency` ran `bundle lock --remove`, a flag that does not
  exist; the old code ignored the failure. Strict setup checks (D02) turned
  this into RVLAB-07 BLOCKED. Fixed to `bundle lock --local` (offline,
  0.3 s, proven); RVLAB-07 re-ran PASS.
- H-14: scenarios that `commit` without a nominal `branch:` advance `main`
  itself, emptying `--base main` diffs (DEEP-CLI-CONSOLE-02 passed vacuously
  until given `branch: lab/deep-console-fail`). Audit: all 173 legacy
  scenarios carry branches; only config-matrix DEEP scenarios omit it, and
  their verdicts are diff-independent. Rule recorded for scenario authors.

## 3. Execution matrix on 1.8.3 (trusted harness, oracle 2.1)

acceptance 17/17 · policy_rejection 4/4 · refusal 32/33 + RVLAB-07 rerun PASS ·
baseline_waiver 5/5 · git_changed_scope 2/2 · determinism 3/3 · multi_fault 1/1 ·
package 1/1 · analyzers 6/6 · DEEP-CLI 17/17 (SARIF 01-06, INV-01, CONSOLE 01-02,
CFG 01-05, INT-01, EXP-01, HO-01). Real analyzer versions observed in evidence
(rubocop 1.89.0, rspec-core 3.13.6, minitest, simplecov 1.0, bundler-audit
0.9.3); a vacuous-pass scare was investigated and cleared (analyzer_results
all succeeded/complete on RVLAB-01).

## 4. Contract points proven beyond the legacy suite

- Usage-error paths carry no gate: oracle judges exit + lab-observed
  stdout/stderr facts (`stdout_empty`, `stderr_contains`, `stdout_contains`,
  `stdout_keys_include`); `UNKNOWN` is an explicit asserted token, documented
  in the oracle self-test, and the refusal-matrix unit test forces every
  UNKNOWN scenario to carry process-fact assertions.
- `check --format sarif` stays a machine-readable SARIF document
  (top-level `version`/`runs` keys asserted).
- Console `Gate: PASS` / `Gate: FAIL` words proven coherent with exits 0/1.
- SIGINT during verification exits 130 with a genuine INCOMPLETE verdict
  (`operational_failures: [interrupted]`); the first flow draft synthesized
  gate PASS and the oracle's UNKNOWN tripwire caught it — the flow now
  returns the real interrupted response.
- Config matrix: unknown version/key, mistype, unparseable YAML, and the
  enabled/required invariant all yield INCOMPLETE/incomplete/2 with a
  `configuration` operational failure.
- `explain` and `handoff create/inspect` round-trip on the CLI (new flows
  with raw artifacts + pass flags from real fields).

## 5. Obligations closed here

O-CLI-EXPLAIN, O-CLI-INVESTIGATE, O-CLI-HANDOFF-CREATE-INSPECT, O-CLI-CONSOLE,
O-CLI-SARIF, O-CLI-INTERRUPT, O-CONFIG → covered (27/58 covered total).
Remaining D04-adjacent depth (adapter fault matrix per adapter, WARN/mode
truth tables, findings-state matrix) executes under D05–D08 nodes against
the same 1.8.3 candidate; D12 re-runs everything.
