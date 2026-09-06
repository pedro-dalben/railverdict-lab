# D11 — Adversarial and compatibility (candidate 1.8.3)

## 1. Oracle fuzz (seed 18282, 42 mutants + edge payloads, all killed)

Dropped fields, type swaps (bool/num/null/array/object), zero counts,
non-array/null findings, 500-item arrays, NUL/ANSI payloads, stated-vs-
findings inconsistencies, malformed findings. Two mutants survived the
first cut and hardened the oracle for real:
- stated counts must agree with present findings on
  introduced/existing/waived, else `inconsistent` FAIL;
- non-array (incl. explicit null) findings with stated counts fail as
  `malformed_findings`.
Both rules are also in `--self-test` (33 checks). Unknown result fields
stay ignored (forward compatibility, deliberate).

## 2. Interaction pairs (each proven by the cited scenario)

dirty×receipt (FRESH-04, SPLIT-01) · policy-drift×receipt/handoff
(POL-13, POL-HANDOFF-01) · targeted×full-required (POL-02, SEL-SEM-01) ·
unavailable×policy (POL-UNAVAIL-01, REV-001) · human-observation×pending
(POL-001) · waived×repair (REPAIR-001/B) · malformed-output×exit (D02
battery, REFUSE series) · old-config×new-command (COMPAT-01, POL-11) ·
lib×RSpec/Minitest (SEL-LIB-01/03) · static-reuse×fresh-tests (REUSE-01) ·
console/JSON coherence (CONSOLE-01/02) · session isolation (SES-01).
No pair left unmapped to evidence.

## 3. Bounds and traversal

Handoff 256 KiB bound (legacy HANDOFF-03), unmapped 9/10/10 cap (D07),
review packet bounds (WF series), traversal/absolute-path rejection on
CLI handoff/receipt verify (ADV-01/02) and MCP (RVLAB-19), 256 KiB
observation cap (schema-enforced, product-unit-covered). Timeout
envelopes exit 124 with partial logs (D02); SIGINT exits 130 with a real
verdict (D04). Grandchild reaping stays unproven (stated limit).

## 4. Compatibility matrix (observed, not promised)

Canonical: ruby 3.4.5, rails 8.1.3.1, rubocop 1.89.0 (lab bundle),
rspec-core 3.13.6, minitest 6.0.6, bundler-audit 0.9.3, simplecov format
1.0, ubuntu 24.04. Boundaries: rubocop 1.90 present on machine but outside
the verified bundle path (untested combination); ruby minimum 3.3 and
alternate rails lines untested here; no Windows/macOS/JRuby claims exist
to verify. Real Brakeman acceptance is blocked by its absence from the
lab bundle (fake-only coverage, stated everywhere it matters).

## 5. Cost (measured, this machine only)

237 timed scenario runs: 1681 s total, 7.1 s mean. Tiered reuse on the
small fixture: 4 subprocess invocations fresh vs 3 reused (analyses 2→1,
gates identical). No universal speedups inferred.

## 6. Obligations

O-CLI-DOCTOR, O-CLI-FINDINGS → covered. O-CLI-CHECK-HANDOFF → covered
via DEEP-REUSE-01. O-MCP-EXPLAIN-INVESTIGATE → covered (previews over
MCP against a real finding). O-POL-HUMAN-REVIEW → covered (high +
medium triggers). O-AN-*, O-ENV → covered with carried edges
(DB-revision transition, ruby/rails pins, brakeman-real). O-CI-SURFACES
stays partial (12/18 surfaces). O-GIT-SCOPE stays partial (empty tree).
Catalog: 230.
