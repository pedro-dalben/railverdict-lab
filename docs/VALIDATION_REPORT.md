# RailVerdict Lab Validation Report

Generated from artifacts/lab-run-summary.json and per-scenario public outputs.

## Candidate Identity

- Version: railverdict 1.4.0
- Source SHA: afd8cd45746de3a2eb2a245a0f6bdc6592aa8938
- Gem SHA-256: 9a84eb95eefc3e4bf26a70e130852df2061a3d39a978cdbea2d1f40126f3b92b
- Verified: true

## Lab Identity

- Lab commit: 1accd19ac6a96243c149def0a652ada45c3db2f6
- Ruby: 3.4.5
- Rails: Rails 8.1.3.1
- Bundler: Bundler version 2.7.1
- Scenario catalog: 4.0

## Executive Result

TOTAL: 118
PASS: 118
FAIL: 0
BLOCKED: 0
SKIPPED: 0

## Category Results

- acceptance: 14/14 passed; 0 skipped
- policy_rejection: 4/4 passed; 0 skipped
- refusal: 18/18 passed; 0 skipped
- baseline_waiver: 5/5 passed; 0 skipped
- git_changed_scope: 2/2 passed; 0 skipped
- repair_anti_cheating: 3/3 passed; 0 skipped
- mcp: 10/10 passed; 0 skipped
- analyzers: 6/6 passed; 0 skipped
- package: 1/1 passed; 0 skipped
- determinism: 2/2 passed; 0 skipped
- multi_fault: 1/1 passed; 0 skipped
- pr_intelligence: 4/4 passed; 0 skipped
- agent: 15/15 passed; 0 skipped
- simplecov: 3/3 passed; 0 skipped
- freshness: 7/7 passed; 0 skipped
- environment: 8/8 passed; 0 skipped
- portability: 4/4 passed; 0 skipped
- repair: 6/6 passed; 0 skipped
- receipt: 5/5 passed; 0 skipped

## Full Scenario Matrix

| ID | Title | Expected | Actual | Exit | Result | Runtime |
|---|---|---|---|---:|---|---:|
| RVLAB-01 | Clean model behavior with a matching test | PASS/0 | PASS | 0 | PASS | 5.625s |
| RVLAB-02 | Historical debt remains non-blocking | PASS/0 | PASS | 0 | PASS | 6.388s |
| RVLAB-03 | New RuboCop offense is rejected | FAIL/1 | FAIL | 1 | PASS | 4.908s |
| RVLAB-04 | Real Minitest failure | FAIL/1 | FAIL | 1 | PASS | 8.088s |
| RVLAB-05 | Real RSpec failure | FAIL/1 | FAIL | 1 | PASS | 4.311s |
| RVLAB-06 | Required test suite with zero tests | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.323s |
| RVLAB-07 | Required analyzer unavailable | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.01s |
| RVLAB-08 | Active waiver is visible and non-blocking | PASS/0 | PASS | 0 | PASS | 8.656s |
| RVLAB-09 | Expired waiver blocks the change | FAIL/1 | FAIL | 1 | PASS | 8.45s |
| RVLAB-10 | Git paths, rename, Unicode, TAB, binary, and empty file | PASS/0 | PASS | 0 | PASS | 4.349s |
| RVLAB-11 | New debt blocks while unrelated debt remains existing | FAIL/1 | FAIL | 1 | PASS | 4.364s |
| RVLAB-12 | Changed-line coverage evidence | PASS/0 | PASS | 0 | PASS | 4.437s |
| RVLAB-13 | Invalid Git base refuses success | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.312s |
| RVLAB-14 | Shallow history without a trustworthy base | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.242s |
| RVLAB-15 | Repair rejects policy weakening | WARN/1 | WARN | 1 | PASS | 10.524s |
| RVLAB-16 | Repair rejects waiver injection | PASS/0 | PASS | 0 | PASS | 10.36s |
| RVLAB-17 | Repair rejects baseline mutation | INCOMPLETE/1 | INCOMPLETE | 1 | PASS | 10.512s |
| RVLAB-18 | Public MCP repair loop succeeds after a real fix | PASS/0 | PASS | 0 | PASS | 10.436s |
| RVLAB-19 | MCP repository path containment | PASS/0 | PASS | 0 | PASS | 5.463s |
| RVLAB-20 | No-new-debt baseline bootstrap | PASS/0 | PASS | 0 | PASS | 11.341s |
| RVLAB-21 | MCP evidence freshness after dirty edits | PASS/0 | PASS | 0 | PASS | 20.405s |
| RVLAB-ACCEPT-01 | Controller/request behavior with a test | PASS/0 | PASS | 0 | PASS | 4.264s |
| RVLAB-ACCEPT-02 | Service object change | PASS/0 | PASS | 0 | PASS | 4.36s |
| RVLAB-ACCEPT-03 | Authorization change with matching test | PASS/0 | PASS | 0 | PASS | 4.313s |
| RVLAB-ACCEPT-04 | Migration and model adjustment | PASS/0 | PASS | 0 | PASS | 4.243s |
| RVLAB-ACCEPT-05 | Route and controller change | PASS/0 | PASS | 0 | PASS | 4.338s |
| RVLAB-ACCEPT-06 | Dependency-neutral refactor | PASS/0 | PASS | 0 | PASS | 4.234s |
| RVLAB-ACCEPT-07 | Test-only improvement | PASS/0 | PASS | 0 | PASS | 4.293s |
| RVLAB-ACCEPT-08 | Resolve existing finding | PASS/0 | PASS | 0 | PASS | 4.321s |
| RVLAB-ACCEPT-09 | Rename/refactor preserving behavior | PASS/0 | PASS | 0 | PASS | 4.345s |
| RVLAB-ACCEPT-10 | Healthy multi-file Rails change | PASS/0 | PASS | 0 | PASS | 4.332s |
| RVLAB-ACCEPT-11 | Public SARIF result remains consumable | PASS/0 | PASS | 0 | PASS | 4.34s |
| RVLAB-REFUSE-01 | Required analyzer executable missing | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.042s |
| RVLAB-REFUSE-02 | Required analyzer timeout | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.145s |
| RVLAB-REFUSE-03 | Analyzer unexpected exit | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.975s |
| RVLAB-REFUSE-04 | Analyzer signaled | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.013s |
| RVLAB-REFUSE-05 | Malformed analyzer JSON | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.029s |
| RVLAB-REFUSE-06 | Analyzer output lacks required JSON | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.996s |
| RVLAB-REFUSE-07 | Required zero-test evidence | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.278s |
| RVLAB-REFUSE-08 | Invalid base in refusal matrix | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.27s |
| RVLAB-REFUSE-09 | Shallow history in refusal matrix | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.251s |
| RVLAB-REFUSE-10 | Missing required baseline | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.733s |
| RVLAB-REFUSE-11 | Invalid baseline data | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.372s |
| RVLAB-REFUSE-12 | Invalid waiver data | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.365s |
| RVLAB-REFUSE-13 | Malformed RailVerdict configuration | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 0.279s |
| RVLAB-REFUSE-14 | Oversized required evidence | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.029s |
| RVLAB-BASELINE-01 | Public baseline creation lifecycle | PASS/0 | PASS | 0 | PASS | 11.046s |
| RVLAB-BASELINE-02 | Invalid baseline is fail-closed | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.352s |
| RVLAB-GIT-01 | Deleted and multi-commit changed scope | PASS/0 | PASS | 0 | PASS | 4.251s |
| RVLAB-ANALYZER-01 | All configured analyzers available and clean | PASS/0 | PASS | 0 | PASS | 4.224s |
| RVLAB-ANALYZER-02 | Bundler-audit public evidence | PASS/0 | PASS | 0 | PASS | 4.255s |
| RVLAB-PACKAGE-01 | Installed package identity and CLI surface | PASS/0 | PASS | 0 | PASS | 2.594s |
| RVLAB-DETERMINISM-01 | Repeated public JSON is deterministic | PASS/0 | PASS | 0 | PASS | 8.65s |
| RVLAB-MULTI-FAULT-01 | Healthy tests plus a real quality regression | FAIL/1 | FAIL | 1 | PASS | 4.324s |
| RVLAB-PR-01 | PR Intelligence basic report | PASS/0 | PASS | 0 | PASS | 4.526s |
| RVLAB-PR-02 | PR Intelligence no-baseline quality delta | PASS/0 | PASS | 0 | PASS | 4.521s |
| RVLAB-PR-03 | PR Intelligence preserves incomplete gate | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.515s |
| RVLAB-PR-04 | PR Intelligence preserves failure gate | FAIL/1 | FAIL | 1 | PASS | 4.644s |
| RVLAB-AGENT-01 | Healthy change: verify, receipt, receipt fresh | PASS/0 | PASS | 0 | PASS | 5.476s |
| RVLAB-AGENT-02 | Source edit after verify makes previous receipt STALE | PASS/0 | PASS | 0 | PASS | 5.528s |
| RVLAB-AGENT-03 | Configuration change after verify makes receipt STALE | PASS/0 | PASS | 0 | PASS | 5.585s |
| RVLAB-AGENT-04 | Baseline change after verify makes receipt STALE | PASS/0 | PASS | 0 | PASS | 5.627s |
| RVLAB-AGENT-05 | FAIL receipt remains FAIL | FAIL/1 | FAIL | 1 | PASS | 5.59s |
| RVLAB-AGENT-06 | INCOMPLETE receipt cannot become successful proof | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.737s |
| RVLAB-AGENT-07 | Repository changes while verification runs: receipt refused | PASS/0 | PASS | 0 | PASS | 2.119s |
| RVLAB-AGENT-08 | PR Intelligence bound to same changed-scope verification | PASS/0 | PASS | 0 | PASS | 4.548s |
| RVLAB-AGENT-09 | MCP verify then derived tools without duplicate verification | PASS/0 | PASS | 0 | PASS | 7.354s |
| RVLAB-AGENT-10 | MCP cached receipt rejected as stale after edit | PASS/0 | PASS | 0 | PASS | 7.298s |
| RVLAB-AGENT-11 | Repair lifecycle ends in a bound PASS receipt | PASS/0 | PASS | 0 | PASS | 14.555s |
| RVLAB-AGENT-12 | Waiver shortcut rejected by integrity boundary | FAIL/0 | FAIL | 0 | PASS | 10.241s |
| RVLAB-AGENT-13 | Two differently named clones produce identical receipt identity | PASS/0 | PASS | 0 | PASS | 8.775s |
| RVLAB-AGENT-14 | Staged index-only mutation invalidates receipt | PASS/0 | PASS | 0 | PASS | 5.662s |
| RVLAB-AGENT-15 | Tampered receipt refused by integrity check | PASS/0 | PASS | 0 | PASS | 4.62s |
| RVLAB-SIMPLECOV-01 | Native SimpleCov JSON normalization and verification | PASS/0 | PASS | 0 | PASS | 4.307s |
| RVLAB-SIMPLECOV-02 | Native SimpleCov JSON low changed-line coverage failure | PASS/0 | PASS | 0 | PASS | 4.249s |
| RVLAB-SIMPLECOV-03 | Native SimpleCov JSON malformed format fail-closed | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.262s |
| RVLAB-ANALYZER-03 | Large legitimate RSpec suite succeeds within safety bounds | PASS/0 | PASS | 0 | PASS | 4.421s |
| RVLAB-ANALYZER-04 | Oversized RSpec output exceeds limit and fails closed without crash | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.083s |
| RVLAB-FINDING-01 | Finding message safety and normalization hardening | FAIL/1 | FAIL | 1 | PASS | 2.062s |
| RVLAB-VERSION-01 | Unknown tool version canonicalization | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.011s |
| RVLAB-DETERMINISM-02 | 20 consecutive executions determinism campaign | PASS/0 | PASS | 0 | PASS | 84.324s |
| RVLAB-FRESH-01 | Fresh receipt remains fresh | PASS/0 | PASS | 0 | PASS | 5.487s |
| RVLAB-FRESH-02 | HEAD change makes receipt stale | PASS/0 | PASS | 0 | PASS | 5.369s |
| RVLAB-FRESH-03 | Index change makes receipt stale | PASS/0 | PASS | 0 | PASS | 5.519s |
| RVLAB-FRESH-04 | Worktree change makes receipt stale | PASS/0 | PASS | 0 | PASS | 5.607s |
| RVLAB-FRESH-05 | Config change makes receipt stale | PASS/0 | PASS | 0 | PASS | 5.564s |
| RVLAB-FRESH-06 | Baseline change makes receipt stale | PASS/0 | PASS | 0 | PASS | 5.584s |
| RVLAB-FRESH-07 | Waivers change makes receipt stale | PASS/0 | PASS | 0 | PASS | 5.44s |
| RVLAB-ENV-01 | Same environment remains fresh | PASS/0 | PASS | 0 | PASS | 5.615s |
| RVLAB-ENV-02 | RailVerdiv version drift makes stale | PASS/0 | PASS | 0 | PASS | 5.556s |
| RVLAB-ENV-03 | Ruby version drift makes stale | PASS/0 | PASS | 0 | PASS | 5.567s |
| RVLAB-ENV-04 | Analyzer version drift makes stale | PASS/0 | PASS | 0 | PASS | 5.545s |
| RVLAB-ENV-05 | Missing analyzer makes unavailable | PASS/0 | PASS | 0 | PASS | 5.571s |
| RVLAB-ENV-06 | Analyzer probe failure makes unavailable | PASS/0 | PASS | 0 | PASS | 5.573s |
| RVLAB-ENV-07 | Irrelevant tool does not invalidate | PASS/0 | PASS | 0 | PASS | 5.573s |
| RVLAB-ENV-08 | Analyzer ordering does not affect digest | PASS/0 | PASS | 0 | PASS | 5.768s |
| RVLAB-PORTABLE-01 | Portable clone 1 remains fresh | PASS/0 | PASS | 0 | PASS | 5.448s |
| RVLAB-PORTABLE-02 | Portable clone 2 remains fresh | PASS/0 | PASS | 0 | PASS | 5.472s |
| RVLAB-PORTABLE-03 | Portable clone 3 remains fresh | PASS/0 | PASS | 0 | PASS | 5.491s |
| RVLAB-PORTABLE-04 | Portable clone 4 remains fresh | PASS/0 | PASS | 0 | PASS | 5.439s |
| RVLAB-MCP-FRESH-01 | MCP fresh 1 | PASS/0 | PASS | 0 | PASS | 5.579s |
| RVLAB-MCP-FRESH-02 | MCP fresh 2 | PASS/0 | PASS | 0 | PASS | 5.494s |
| RVLAB-MCP-FRESH-03 | MCP fresh 3 | PASS/0 | PASS | 0 | PASS | 5.56s |
| RVLAB-MCP-FRESH-04 | MCP fresh 4 | PASS/0 | PASS | 0 | PASS | 5.581s |
| RVLAB-MCP-FRESH-05 | MCP fresh 5 | PASS/0 | PASS | 0 | PASS | 5.591s |
| RVLAB-MCP-FRESH-06 | MCP fresh 6 | PASS/0 | PASS | 0 | PASS | 5.576s |
| RVLAB-MCP-FRESH-07 | MCP fresh 7 | PASS/0 | PASS | 0 | PASS | 5.443s |
| RVLAB-REPAIR-BOUNDARY-01 | Real fix succeeds | PASS/0 | PASS | 0 | PASS | 5.569s |
| RVLAB-REPAIR-BOUNDARY-02 | Waiver injection fails | PASS/0 | PASS | 0 | PASS | 5.638s |
| RVLAB-REPAIR-BOUNDARY-03 | Baseline injection fails | PASS/0 | PASS | 0 | PASS | 5.703s |
| RVLAB-REPAIR-BOUNDARY-04 | Config weakening fails | PASS/0 | PASS | 0 | PASS | 5.596s |
| RVLAB-REPAIR-BOUNDARY-05 | Fix plus boundary fails | PASS/0 | PASS | 0 | PASS | 5.615s |
| RVLAB-REPAIR-BOUNDARY-06 | RVLAB-16 fixed | PASS/0 | PASS | 0 | PASS | 5.507s |
| RVLAB-RECEIPT-13X-01 | Receipt integrity 1 | PASS/0 | PASS | 0 | PASS | 5.674s |
| RVLAB-RECEIPT-13X-02 | Receipt integrity 2 | PASS/0 | PASS | 0 | PASS | 5.644s |
| RVLAB-RECEIPT-13X-03 | Receipt integrity 3 | PASS/0 | PASS | 0 | PASS | 5.535s |
| RVLAB-RECEIPT-13X-04 | Receipt integrity 4 | PASS/0 | PASS | 0 | PASS | 5.44s |
| RVLAB-RECEIPT-13X-05 | Receipt integrity 5 | PASS/0 | PASS | 0 | PASS | 5.51s |

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

Expected FAIL/INCOMPLETE observed as PASS: NO.

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

VALIDATION PASS
