# D08 — Engineering policy depth (candidate 1.8.3)

## 1. Legacy execution

engineering_policy 15/15 on 1.8.3.

## 2. New scenarios (12, all PASS)

- Coverage boundaries on one fixture shape (11–13 of 14 lines):
  78.57% vs min 84 → violated; 85.71% vs min 85 → satisfied;
  85.71% vs min 86 → violated (strictness); 92.86% vs min 86 → satisfied.
  Lesson captured: non-code changed files without a nil-covered entry in
  the coverage document dilute the percent (the yml rewrite counted as
  executable-missing until nil-listed, the POL-05/06 pattern).
- HIGH forbid: simulated high-confidence Brakeman SQLi → requirement
  violated, decision FAIL — while the scope-sensitive gate stays PASS
  (finding outside the diff). Gate/finding-scope vs rule-scope split is
  contract, verified at `verification/policy.rb:167-168`.
- Required-but-disabled analyzer → `unavailable`, decision INCOMPLETE
  (never a fabricated violation).
- Minimum 0/101/wrong-type → fail-closed usage error, exit 2, empty
  stdout (message says "readable configuration file", a wart worth a
  clearer sentence someday, behavior correct).
- Handoff + strengthened policy → re-verified under the current rule to
  INCOMPLETE (coverage unavailable), never replaying the old PASS.
  (First draft wrongly used `check`, which does not evaluate policy —
  corrected to `policy --handoff`.)
- Config 1.0 → only mode-gated baseline machinery, decision mirrors gate.

## 3. Independent decision table (observed)

| Requirements \ Gate | PASS | FAIL |
|---|---|---|
| all satisfied / not_applicable | PASS / 0 | FAIL / 1 |
| any violated | FAIL / 1 | FAIL / 1 |
| any unavailable (no violated) | INCOMPLETE / 2 | INCOMPLETE / 2 |
| review_required (no above) | REVIEW_REQUIRED / 3 | REVIEW_REQUIRED / 3 |

Precedence violated → unavailable → review_required → mirror gate, per
`engineering_policy.rb:300-313`; exit ladder 0/1/2/3 confirmed live
(POL-10 covers exit 3). WARN mirrors to PASS.

## 4. Obligations

O-POL-NEW-FINDINGS, O-POL-COVERAGE, O-POL-ANALYZERS, O-POL-SCOPE,
O-POL-BASELINE-COMPAT, O-POL-HUMAN-REVIEW (legacy), O-POL-DRIFT,
O-POL-COMPAT → covered. O-POL-GATE-MIRROR stays not_applicable (no
requirement object by design). Carried: real-Brakeman-high acceptance
(no Brakeman in the lab bundle), truncated-FULL-scope pair. Catalog: 218.
