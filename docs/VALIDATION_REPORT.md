# RailVerdict Lab Validation Report

Generated from artifacts/lab-run-summary.json and per-scenario public outputs.

## Candidate Identity

- Version: railverdict 1.0.1
- Source SHA: unknown for published gem
- Gem SHA-256: 5a4a425ede8ea1563cca4e641e874a41b95a6f2e51eb96e759909e4f8979d3a9
- Verified: true

## Lab Identity

- Lab commit: 3d3a2c2e53caa37c44f9f7fa7d2caced89d67b22
- Ruby: 3.4.5
- Rails: Rails 8.1.3.1
- Bundler: Bundler version 2.7.1
- Scenario catalog: 2.0

## Executive Result

TOTAL: 57
PASS: 47
FAIL: 5
BLOCKED: 0
SKIPPED: 5

## Category Results

- acceptance: 13/13 passed; 0 skipped
- policy_rejection: 4/4 passed; 0 skipped
- refusal: 15/17 passed; 1 skipped
- baseline_waiver: 5/5 passed; 0 skipped
- git_changed_scope: 1/2 passed; 0 skipped
- repair_anti_cheating: 2/3 passed; 0 skipped
- mcp: 3/3 passed; 0 skipped
- analyzers: 2/2 passed; 0 skipped
- package: 1/1 passed; 0 skipped
- determinism: 0/1 passed; 0 skipped
- multi_fault: 1/1 passed; 0 skipped
- pr_intelligence: 0/0 passed; 4 skipped

## Full Scenario Matrix

| ID | Title | Expected | Actual | Exit | Result | Runtime |
|---|---|---|---|---:|---|---:|
| RVLAB-01 | Clean model behavior with a matching test | PASS/0 | PASS | 0 | PASS | 4.053s |
| RVLAB-02 | Historical debt remains non-blocking | PASS/0 | PASS | 0 | PASS | 4.071s |
| RVLAB-03 | New RuboCop offense is rejected | FAIL/1 | FAIL | 1 | PASS | 4.017s |
| RVLAB-04 | Real Minitest failure | FAIL/1 | FAIL | 1 | PASS | 7.342s |
| RVLAB-05 | Real RSpec failure | FAIL/1 | FAIL | 1 | PASS | 4.05s |
| RVLAB-06 | Required test suite with zero tests | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.081s |
| RVLAB-07 | Required analyzer unavailable | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.757s |
| RVLAB-08 | Active waiver is visible and non-blocking | PASS/0 | PASS | 0 | PASS | 8.294s |
| RVLAB-09 | Expired waiver blocks the change | FAIL/1 | FAIL | 1 | PASS | 8.132s |
| RVLAB-10 | Git paths, rename, Unicode, TAB, binary, and empty file | PASS/0 | PASS | 0 | PASS | 4.041s |
| RVLAB-11 | New debt blocks while unrelated debt remains existing | FAIL/1 | FAIL | 1 | PASS | 4.066s |
| RVLAB-12 | Changed-line coverage evidence | PASS/0 | PASS | 0 | PASS | 4.087s |
| RVLAB-13 | Invalid Git base refuses success | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.265s |
| RVLAB-14 | Shallow history without a trustworthy base | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.215s |
| RVLAB-15 | Repair rejects policy weakening | WARN/1 | WARN | 1 | PASS | 7.974s |
| RVLAB-16 | Repair rejects waiver injection | FAIL/1 | PASS | 0 | FAIL | 7.952s |
| RVLAB-17 | Repair rejects baseline mutation | INCOMPLETE/1 | INCOMPLETE | 1 | PASS | 7.886s |
| RVLAB-18 | Public MCP repair loop succeeds after a real fix | PASS/0 | PASS | 0 | PASS | 7.927s |
| RVLAB-19 | MCP repository path containment | PASS/0 | PASS | 0 | PASS | 4.128s |
| RVLAB-20 | No-new-debt baseline bootstrap | PASS/0 | PASS | 0 | PASS | 10.42s |
| RVLAB-21 | MCP evidence freshness after dirty edits | PASS/0 | PASS | 0 | PASS | 11.94s |
| RVLAB-ACCEPT-01 | Controller/request behavior with a test | PASS/0 | PASS | 0 | PASS | 4.091s |
| RVLAB-ACCEPT-02 | Service object change | PASS/0 | PASS | 0 | PASS | 4.054s |
| RVLAB-ACCEPT-03 | Authorization change with matching test | PASS/0 | PASS | 0 | PASS | 4.1s |
| RVLAB-ACCEPT-04 | Migration and model adjustment | PASS/0 | PASS | 0 | PASS | 4.06s |
| RVLAB-ACCEPT-05 | Route and controller change | PASS/0 | PASS | 0 | PASS | 4.129s |
| RVLAB-ACCEPT-06 | Dependency-neutral refactor | PASS/0 | PASS | 0 | PASS | 4.167s |
| RVLAB-ACCEPT-07 | Test-only improvement | PASS/0 | PASS | 0 | PASS | 4.065s |
| RVLAB-ACCEPT-08 | Resolve existing finding | PASS/0 | PASS | 0 | PASS | 4.375s |
| RVLAB-ACCEPT-09 | Rename/refactor preserving behavior | PASS/0 | PASS | 0 | PASS | 4.097s |
| RVLAB-ACCEPT-10 | Healthy multi-file Rails change | PASS/0 | PASS | 0 | PASS | 4.254s |
| RVLAB-REFUSE-01 | Required analyzer executable missing | INCOMPLETE/2 | UNKNOWN | 1 | FAIL | 0.725s |
| RVLAB-REFUSE-02 | Required analyzer timeout | INCOMPLETE/2 | UNKNOWN | - | SKIPPED | 0.0s |
| RVLAB-REFUSE-03 | Analyzer unexpected exit | INCOMPLETE/2 | UNKNOWN | 1 | FAIL | 0.724s |
| RVLAB-REFUSE-04 | Analyzer signaled | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.926s |
| RVLAB-REFUSE-05 | Malformed analyzer JSON | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.961s |
| RVLAB-REFUSE-06 | Analyzer output lacks required JSON | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.965s |
| RVLAB-REFUSE-07 | Required zero-test evidence | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.201s |
| RVLAB-REFUSE-08 | Invalid base in refusal matrix | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.228s |
| RVLAB-REFUSE-09 | Shallow history in refusal matrix | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.208s |
| RVLAB-REFUSE-10 | Missing required baseline | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.563s |
| RVLAB-REFUSE-11 | Invalid baseline data | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.277s |
| RVLAB-REFUSE-12 | Invalid waiver data | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.036s |
| RVLAB-REFUSE-13 | Malformed RailVerdict configuration | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 0.269s |
| RVLAB-REFUSE-14 | Oversized required evidence | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.92s |
| RVLAB-BASELINE-01 | Public baseline creation lifecycle | PASS/0 | PASS | 0 | PASS | 10.409s |
| RVLAB-BASELINE-02 | Invalid baseline is fail-closed | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.101s |
| RVLAB-GIT-01 | Deleted and multi-commit changed scope | PASS/0 | PASS | 0 | FAIL | 4.016s |
| RVLAB-ANALYZER-01 | All configured analyzers available and clean | PASS/0 | PASS | 0 | PASS | 4.125s |
| RVLAB-ANALYZER-02 | Bundler-audit public evidence | PASS/0 | PASS | 0 | PASS | 4.073s |
| RVLAB-PACKAGE-01 | Installed package identity and CLI surface | PASS/0 | PASS | 0 | PASS | 2.484s |
| RVLAB-DETERMINISM-01 | Repeated public JSON is deterministic | PASS/0 | PASS | 0 | FAIL | 8.101s |
| RVLAB-MULTI-FAULT-01 | Healthy tests plus a real quality regression | FAIL/1 | FAIL | 1 | PASS | 4.058s |
| RVLAB-PR-01 | PR Intelligence basic report | PASS/0 | UNKNOWN | - | SKIPPED | 0.0s |
| RVLAB-PR-02 | PR Intelligence no-baseline quality delta | PASS/0 | UNKNOWN | - | SKIPPED | 0.0s |
| RVLAB-PR-03 | PR Intelligence preserves incomplete gate | INCOMPLETE/2 | UNKNOWN | - | SKIPPED | 0.0s |
| RVLAB-PR-04 | PR Intelligence preserves failure gate | FAIL/1 | UNKNOWN | - | SKIPPED | 0.0s |

## Refusal Evidence

| Scenario | Expected | Actual | Result |
|---|---|---|---|
| RVLAB-06 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-07 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-13 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-14 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-01 | INCOMPLETE/2 | UNKNOWN | FAIL |
| RVLAB-REFUSE-02 | INCOMPLETE/2 | UNKNOWN | SKIPPED |
| RVLAB-REFUSE-03 | INCOMPLETE/2 | UNKNOWN | FAIL |
| RVLAB-REFUSE-04 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-05 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-06 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-07 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-08 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-09 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-10 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-11 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-12 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-13 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-14 | INCOMPLETE/2 | INCOMPLETE | PASS |

## False-Pass Analysis

Expected FAIL/INCOMPLETE observed as PASS: YES.
- RVLAB-16 — Repair rejects waiver injection

## Determinism

Observed result: FAIL.

## Performance

Runtime values are measured in this environment only; they are not benchmarks.

## Product Defects Found

- RVLAB-FINDING-001.md
- RVLAB-FINDING-002.md
- RVLAB-FINDING-003.md
- RVLAB-FINDING-004.md

## Limitations of This Campaign

- PR Intelligence scenarios are capability-gated and are skipped when the frozen candidate has no public pr command.
- External client/player behavior and hosted CI remain outside this local campaign.

## Final Verdict

VALIDATION FAIL
