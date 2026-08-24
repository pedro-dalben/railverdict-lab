# RailVerdict Lab Validation Report

Generated from artifacts/lab-run-summary.json and per-scenario public outputs.

## Candidate Identity

- Version: railverdict 1.2.0
- Source SHA: d49c204b36fe89a6fcf5f22fd4c42978362b10d2
- Gem SHA-256: 564fe3ce8d8030898e1fe015452474ce8e21e0e3d34184fffc0de67dcb281381
- Verified: true

## Lab Identity

- Lab commit: 4789a5f80c588a8878f7ba5f58b066423a55cae9
- Ruby: 3.4.5
- Rails: Rails 8.1.3.1
- Bundler: Bundler version 2.7.1
- Scenario catalog: 2.0

## Executive Result

TOTAL: 81
PASS: 80
FAIL: 1
BLOCKED: 0
SKIPPED: 0

## Category Results

- acceptance: 14/14 passed; 0 skipped
- policy_rejection: 4/4 passed; 0 skipped
- refusal: 18/18 passed; 0 skipped
- baseline_waiver: 5/5 passed; 0 skipped
- git_changed_scope: 2/2 passed; 0 skipped
- repair_anti_cheating: 2/3 passed; 0 skipped
- mcp: 3/3 passed; 0 skipped
- analyzers: 6/6 passed; 0 skipped
- package: 1/1 passed; 0 skipped
- determinism: 2/2 passed; 0 skipped
- multi_fault: 1/1 passed; 0 skipped
- pr_intelligence: 4/4 passed; 0 skipped
- agent: 15/15 passed; 0 skipped
- simplecov: 3/3 passed; 0 skipped

## Full Scenario Matrix

| ID | Title | Expected | Actual | Exit | Result | Runtime |
|---|---|---|---|---:|---|---:|
| RVLAB-01 | Clean model behavior with a matching test | PASS/0 | PASS | 0 | PASS | 5.207s |
| RVLAB-02 | Historical debt remains non-blocking | PASS/0 | PASS | 0 | PASS | 4.816s |
| RVLAB-03 | New RuboCop offense is rejected | FAIL/1 | FAIL | 1 | PASS | 4.862s |
| RVLAB-04 | Real Minitest failure | FAIL/1 | FAIL | 1 | PASS | 8.251s |
| RVLAB-05 | Real RSpec failure | FAIL/1 | FAIL | 1 | PASS | 4.768s |
| RVLAB-06 | Required test suite with zero tests | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 5.2s |
| RVLAB-07 | Required analyzer unavailable | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.679s |
| RVLAB-08 | Active waiver is visible and non-blocking | PASS/0 | PASS | 0 | PASS | 10.232s |
| RVLAB-09 | Expired waiver blocks the change | FAIL/1 | FAIL | 1 | PASS | 9.989s |
| RVLAB-10 | Git paths, rename, Unicode, TAB, binary, and empty file | PASS/0 | PASS | 0 | PASS | 5.018s |
| RVLAB-11 | New debt blocks while unrelated debt remains existing | FAIL/1 | FAIL | 1 | PASS | 4.948s |
| RVLAB-12 | Changed-line coverage evidence | PASS/0 | PASS | 0 | PASS | 4.857s |
| RVLAB-13 | Invalid Git base refuses success | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.443s |
| RVLAB-14 | Shallow history without a trustworthy base | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.425s |
| RVLAB-15 | Repair rejects policy weakening | WARN/1 | WARN | 1 | PASS | 9.489s |
| RVLAB-16 | Repair rejects waiver injection | FAIL/1 | PASS | 0 | FAIL | 9.632s |
| RVLAB-17 | Repair rejects baseline mutation | INCOMPLETE/1 | INCOMPLETE | 1 | PASS | 10.01s |
| RVLAB-18 | Public MCP repair loop succeeds after a real fix | PASS/0 | PASS | 0 | PASS | 9.235s |
| RVLAB-19 | MCP repository path containment | PASS/0 | PASS | 0 | PASS | 4.761s |
| RVLAB-20 | No-new-debt baseline bootstrap | PASS/0 | PASS | 0 | PASS | 14.082s |
| RVLAB-21 | MCP evidence freshness after dirty edits | PASS/0 | PASS | 0 | PASS | 19.741s |
| RVLAB-ACCEPT-01 | Controller/request behavior with a test | PASS/0 | PASS | 0 | PASS | 5.24s |
| RVLAB-ACCEPT-02 | Service object change | PASS/0 | PASS | 0 | PASS | 4.685s |
| RVLAB-ACCEPT-03 | Authorization change with matching test | PASS/0 | PASS | 0 | PASS | 4.803s |
| RVLAB-ACCEPT-04 | Migration and model adjustment | PASS/0 | PASS | 0 | PASS | 5.331s |
| RVLAB-ACCEPT-05 | Route and controller change | PASS/0 | PASS | 0 | PASS | 5.524s |
| RVLAB-ACCEPT-06 | Dependency-neutral refactor | PASS/0 | PASS | 0 | PASS | 4.614s |
| RVLAB-ACCEPT-07 | Test-only improvement | PASS/0 | PASS | 0 | PASS | 4.528s |
| RVLAB-ACCEPT-08 | Resolve existing finding | PASS/0 | PASS | 0 | PASS | 4.669s |
| RVLAB-ACCEPT-09 | Rename/refactor preserving behavior | PASS/0 | PASS | 0 | PASS | 4.737s |
| RVLAB-ACCEPT-10 | Healthy multi-file Rails change | PASS/0 | PASS | 0 | PASS | 4.95s |
| RVLAB-ACCEPT-11 | Public SARIF result remains consumable | PASS/0 | PASS | 0 | PASS | 4.769s |
| RVLAB-REFUSE-01 | Required analyzer executable missing | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.24s |
| RVLAB-REFUSE-02 | Required analyzer timeout | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.349s |
| RVLAB-REFUSE-03 | Analyzer unexpected exit | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.327s |
| RVLAB-REFUSE-04 | Analyzer signaled | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.234s |
| RVLAB-REFUSE-05 | Malformed analyzer JSON | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.133s |
| RVLAB-REFUSE-06 | Analyzer output lacks required JSON | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.15s |
| RVLAB-REFUSE-07 | Required zero-test evidence | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.635s |
| RVLAB-REFUSE-08 | Invalid base in refusal matrix | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.375s |
| RVLAB-REFUSE-09 | Shallow history in refusal matrix | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.375s |
| RVLAB-REFUSE-10 | Missing required baseline | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.93s |
| RVLAB-REFUSE-11 | Invalid baseline data | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.463s |
| RVLAB-REFUSE-12 | Invalid waiver data | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.639s |
| RVLAB-REFUSE-13 | Malformed RailVerdict configuration | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 0.292s |
| RVLAB-REFUSE-14 | Oversized required evidence | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.236s |
| RVLAB-BASELINE-01 | Public baseline creation lifecycle | PASS/0 | PASS | 0 | PASS | 11.98s |
| RVLAB-BASELINE-02 | Invalid baseline is fail-closed | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.825s |
| RVLAB-GIT-01 | Deleted and multi-commit changed scope | PASS/0 | PASS | 0 | PASS | 4.673s |
| RVLAB-ANALYZER-01 | All configured analyzers available and clean | PASS/0 | PASS | 0 | PASS | 4.967s |
| RVLAB-ANALYZER-02 | Bundler-audit public evidence | PASS/0 | PASS | 0 | PASS | 4.981s |
| RVLAB-PACKAGE-01 | Installed package identity and CLI surface | PASS/0 | PASS | 0 | PASS | 3.131s |
| RVLAB-DETERMINISM-01 | Repeated public JSON is deterministic | PASS/0 | PASS | 0 | PASS | 9.645s |
| RVLAB-MULTI-FAULT-01 | Healthy tests plus a real quality regression | FAIL/1 | FAIL | 1 | PASS | 4.998s |
| RVLAB-PR-01 | PR Intelligence basic report | PASS/0 | PASS | 0 | PASS | 4.812s |
| RVLAB-PR-02 | PR Intelligence no-baseline quality delta | PASS/0 | PASS | 0 | PASS | 4.804s |
| RVLAB-PR-03 | PR Intelligence preserves incomplete gate | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.604s |
| RVLAB-PR-04 | PR Intelligence preserves failure gate | FAIL/1 | FAIL | 1 | PASS | 4.835s |
| RVLAB-AGENT-01 | Healthy change: verify, receipt, receipt fresh | PASS/0 | PASS | 0 | PASS | 5.696s |
| RVLAB-AGENT-02 | Source edit after verify makes previous receipt STALE | PASS/0 | PASS | 0 | PASS | 6.634s |
| RVLAB-AGENT-03 | Configuration change after verify makes receipt STALE | PASS/0 | PASS | 0 | PASS | 7.698s |
| RVLAB-AGENT-04 | Baseline change after verify makes receipt STALE | PASS/0 | PASS | 0 | PASS | 8.344s |
| RVLAB-AGENT-05 | FAIL receipt remains FAIL | FAIL/1 | FAIL | 1 | PASS | 8.534s |
| RVLAB-AGENT-06 | INCOMPLETE receipt cannot become successful proof | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.889s |
| RVLAB-AGENT-07 | Repository changes while verification runs: receipt refused | PASS/0 | PASS | 0 | PASS | 3.594s |
| RVLAB-AGENT-08 | PR Intelligence bound to same changed-scope verification | PASS/0 | PASS | 0 | PASS | 7.544s |
| RVLAB-AGENT-09 | MCP verify then derived tools without duplicate verification | PASS/0 | PASS | 0 | PASS | 6.937s |
| RVLAB-AGENT-10 | MCP cached receipt rejected as stale after edit | PASS/0 | PASS | 0 | PASS | 6.57s |
| RVLAB-AGENT-11 | Repair lifecycle ends in a bound PASS receipt | PASS/0 | PASS | 0 | PASS | 14.963s |
| RVLAB-AGENT-12 | Waiver shortcut rejected by integrity boundary | FAIL/0 | FAIL | 0 | PASS | 10.256s |
| RVLAB-AGENT-13 | Two differently named clones produce identical receipt identity | PASS/0 | PASS | 0 | PASS | 9.892s |
| RVLAB-AGENT-14 | Staged index-only mutation invalidates receipt | PASS/0 | PASS | 0 | PASS | 5.061s |
| RVLAB-AGENT-15 | Tampered receipt refused by integrity check | PASS/0 | PASS | 0 | PASS | 5.232s |
| RVLAB-SIMPLECOV-01 | Native SimpleCov JSON normalization and verification | PASS/0 | PASS | 0 | PASS | 4.754s |
| RVLAB-SIMPLECOV-02 | Native SimpleCov JSON low changed-line coverage failure | PASS/0 | PASS | 0 | PASS | 4.624s |
| RVLAB-SIMPLECOV-03 | Native SimpleCov JSON malformed format fail-closed | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.475s |
| RVLAB-ANALYZER-03 | Large legitimate RSpec suite succeeds within safety bounds | PASS/0 | PASS | 0 | PASS | 4.755s |
| RVLAB-ANALYZER-04 | Oversized RSpec output exceeds limit and fails closed without crash | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.217s |
| RVLAB-FINDING-01 | Finding message safety and normalization hardening | FAIL/1 | FAIL | 1 | PASS | 2.158s |
| RVLAB-VERSION-01 | Unknown tool version canonicalization | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.187s |
| RVLAB-DETERMINISM-02 | 20 consecutive executions determinism campaign | PASS/0 | PASS | 0 | PASS | 88.964s |

## Refusal Evidence

| Scenario | Expected | Actual | Result |
|---|---|---|---|
| RVLAB-06 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-07 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-13 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-14 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-01 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-02 | INCOMPLETE/2 | INCOMPLETE | PASS |
| RVLAB-REFUSE-03 | INCOMPLETE/2 | INCOMPLETE | PASS |
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

Observed result: PASS.

## Performance

Runtime values are measured in this environment only; they are not benchmarks.

## Product Defects Found

- RVLAB-FINDING-001.md
- RVLAB-FINDING-002.md
- RVLAB-FINDING-003.md
- RVLAB-FINDING-004.md

## Limitations of This Campaign

- PR Intelligence scenarios are capability-gated and are skipped when the frozen candidate has no public pr command.
- RVLAB-REFUSE-02 is capability-gated and is skipped because the frozen candidate declares no per-analyzer timeout capability.
- External client/player behavior and hosted CI remain outside this local campaign.

## Final Verdict

VALIDATION FAIL
