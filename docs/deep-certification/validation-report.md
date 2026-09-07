# RailVerdict Lab Validation Report

Generated from artifacts/lab-run-summary.json and per-scenario public outputs.

## Candidate Identity

- Version: railverdict 1.8.3
- Source SHA: 8e41472706679df7c2bf068824058f028e221ced
- Gem SHA-256: 6ed0275ce602cffd1172f2fc3444c6aa731325be6b15c187d9778a15f3bf19ad
- Verified: true

## Lab Identity

- Lab commit: c81c508e30a740802d5d6bf33cca2fb0290ac14b
- Ruby: 3.4.5
- Rails: Rails 8.1.3.1
- Bundler: Bundler version 2.7.1
- Scenario catalog: 5.0

## Executive Result

TOTAL: 245
PASS: 245
FAIL: 0
BLOCKED: 0
SKIPPED: 0

## Category Results

- acceptance: 22/22 passed; 0 skipped
- policy_rejection: 4/4 passed; 0 skipped
- refusal: 34/34 passed; 0 skipped
- baseline_waiver: 5/5 passed; 0 skipped
- git_changed_scope: 3/3 passed; 0 skipped
- repair_anti_cheating: 3/3 passed; 0 skipped
- mcp: 14/14 passed; 0 skipped
- analyzers: 6/6 passed; 0 skipped
- package: 1/1 passed; 0 skipped
- determinism: 2/2 passed; 0 skipped
- multi_fault: 1/1 passed; 0 skipped
- pr_intelligence: 29/29 passed; 0 skipped
- agent: 15/15 passed; 0 skipped
- simplecov: 3/3 passed; 0 skipped
- freshness: 8/8 passed; 0 skipped
- environment: 8/8 passed; 0 skipped
- portability: 4/4 passed; 0 skipped
- repair: 7/7 passed; 0 skipped
- receipt: 5/5 passed; 0 skipped
- hardening: 14/14 passed; 0 skipped
- security: 2/2 passed; 0 skipped
- test_selection: 7/7 passed; 0 skipped
- change_intelligence: 10/10 passed; 0 skipped
- engineering_policy: 24/24 passed; 0 skipped
- review_workflow: 14/14 passed; 0 skipped

## Full Scenario Matrix

| ID | Title | Expected | Actual | Exit | Result | Runtime |
|---|---|---|---|---:|---|---:|
| RVLAB-01 | Clean model behavior with a matching test | PASS/0 | PASS | 0 | PASS | 6.823s |
| RVLAB-02 | Historical debt remains non-blocking | PASS/0 | PASS | 0 | PASS | 6.707s |
| RVLAB-03 | New RuboCop offense is rejected | FAIL/1 | FAIL | 1 | PASS | 6.298s |
| RVLAB-04 | Real Minitest failure | FAIL/1 | FAIL | 1 | PASS | 10.009s |
| RVLAB-05 | Real RSpec failure | FAIL/1 | FAIL | 1 | PASS | 6.741s |
| RVLAB-06 | Required test suite with zero tests | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 6.557s |
| RVLAB-07 | Required analyzer unavailable | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 6.312s |
| RVLAB-08 | Active waiver is visible and non-blocking | PASS/0 | PASS | 0 | PASS | 12.67s |
| RVLAB-09 | Expired waiver blocks the change | FAIL/1 | FAIL | 1 | PASS | 12.453s |
| RVLAB-10 | Git paths, rename, Unicode, TAB, binary, and empty file | PASS/0 | PASS | 0 | PASS | 6.896s |
| RVLAB-11 | New debt blocks while unrelated debt remains existing | FAIL/1 | FAIL | 1 | PASS | 6.47s |
| RVLAB-12 | Changed-line coverage evidence | PASS/0 | PASS | 0 | PASS | 6.598s |
| RVLAB-13 | Invalid Git base refuses success | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.062s |
| RVLAB-14 | Shallow history without a trustworthy base | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.836s |
| RVLAB-15 | Repair rejects policy weakening | WARN/1 | WARN | 1 | PASS | 16.016s |
| RVLAB-16 | Repair rejects waiver injection | PASS/0 | PASS | 0 | PASS | 15.905s |
| RVLAB-17 | Repair rejects baseline mutation | INCOMPLETE/1 | INCOMPLETE | 1 | PASS | 15.947s |
| RVLAB-18 | Public MCP repair loop succeeds after a real fix | PASS/0 | PASS | 0 | PASS | 15.706s |
| RVLAB-19 | MCP repository path containment | PASS/0 | PASS | 0 | PASS | 8.275s |
| RVLAB-20 | No-new-debt baseline bootstrap | PASS/0 | PASS | 0 | PASS | 16.733s |
| RVLAB-21 | MCP evidence freshness after dirty edits | PASS/0 | PASS | 0 | PASS | 30.759s |
| RVLAB-ACCEPT-01 | Controller/request behavior with a test | PASS/0 | PASS | 0 | PASS | 6.82s |
| RVLAB-ACCEPT-02 | Service object change | PASS/0 | PASS | 0 | PASS | 6.846s |
| RVLAB-ACCEPT-03 | Authorization change with matching test | PASS/0 | PASS | 0 | PASS | 7.053s |
| RVLAB-ACCEPT-04 | Migration and model adjustment | PASS/0 | PASS | 0 | PASS | 6.839s |
| RVLAB-ACCEPT-05 | Route and controller change | PASS/0 | PASS | 0 | PASS | 6.497s |
| RVLAB-ACCEPT-06 | Dependency-neutral refactor | PASS/0 | PASS | 0 | PASS | 6.605s |
| RVLAB-ACCEPT-07 | Test-only improvement | PASS/0 | PASS | 0 | PASS | 6.353s |
| RVLAB-ACCEPT-08 | Resolve existing finding | PASS/0 | PASS | 0 | PASS | 6.717s |
| RVLAB-ACCEPT-09 | Rename/refactor preserving behavior | PASS/0 | PASS | 0 | PASS | 6.742s |
| RVLAB-ACCEPT-10 | Healthy multi-file Rails change | PASS/0 | PASS | 0 | PASS | 6.609s |
| RVLAB-ACCEPT-11 | Public SARIF result remains consumable | PASS/0 | PASS | 0 | PASS | 7.055s |
| RVLAB-REFUSE-01 | Required analyzer executable missing | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.233s |
| RVLAB-REFUSE-02 | Required analyzer timeout | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.273s |
| RVLAB-REFUSE-03 | Analyzer unexpected exit | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.164s |
| RVLAB-REFUSE-04 | Analyzer signaled | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.136s |
| RVLAB-REFUSE-05 | Malformed analyzer JSON | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.049s |
| RVLAB-REFUSE-06 | Analyzer output lacks required JSON | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.646s |
| RVLAB-REFUSE-07 | Required zero-test evidence | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 6.746s |
| RVLAB-REFUSE-08 | Invalid base in refusal matrix | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.817s |
| RVLAB-REFUSE-09 | Shallow history in refusal matrix | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 1.977s |
| RVLAB-REFUSE-10 | Missing required baseline | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.831s |
| RVLAB-REFUSE-11 | Invalid baseline data | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 6.816s |
| RVLAB-REFUSE-12 | Invalid waiver data | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 6.777s |
| RVLAB-REFUSE-13 | Malformed RailVerdict configuration | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 0.503s |
| RVLAB-REFUSE-14 | Oversized required evidence | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.022s |
| RVLAB-BASELINE-01 | Public baseline creation lifecycle | PASS/0 | PASS | 0 | PASS | 16.315s |
| RVLAB-BASELINE-02 | Invalid baseline is fail-closed | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 6.545s |
| RVLAB-GIT-01 | Deleted and multi-commit changed scope | PASS/0 | PASS | 0 | PASS | 6.485s |
| RVLAB-ANALYZER-01 | All configured analyzers available and clean | PASS/0 | PASS | 0 | PASS | 6.501s |
| RVLAB-ANALYZER-02 | Bundler-audit public evidence | PASS/0 | PASS | 0 | PASS | 6.318s |
| RVLAB-PACKAGE-01 | Installed package identity and CLI surface | PASS/0 | PASS | 0 | PASS | 4.173s |
| RVLAB-DETERMINISM-01 | Repeated public JSON is deterministic | PASS/0 | PASS | 0 | PASS | 12.865s |
| RVLAB-MULTI-FAULT-01 | Healthy tests plus a real quality regression | FAIL/1 | FAIL | 1 | PASS | 6.757s |
| RVLAB-PR-01 | PR Intelligence basic report | PASS/0 | PASS | 0 | PASS | 6.946s |
| RVLAB-PR-02 | PR Intelligence no-baseline quality delta | PASS/0 | PASS | 0 | PASS | 7.049s |
| RVLAB-PR-03 | PR Intelligence preserves incomplete gate | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 2.294s |
| RVLAB-PR-04 | PR Intelligence preserves failure gate | FAIL/1 | FAIL | 1 | PASS | 6.74s |
| RVLAB-AGENT-01 | Healthy change: verify, receipt, receipt fresh | PASS/0 | PASS | 0 | PASS | 7.989s |
| RVLAB-AGENT-02 | Source edit after verify makes previous receipt STALE | PASS/0 | PASS | 0 | PASS | 8.382s |
| RVLAB-AGENT-03 | Configuration change after verify makes receipt STALE | PASS/0 | PASS | 0 | PASS | 8.356s |
| RVLAB-AGENT-04 | Baseline change after verify makes receipt STALE | PASS/0 | PASS | 0 | PASS | 8.62s |
| RVLAB-AGENT-05 | FAIL receipt remains FAIL | FAIL/1 | FAIL | 1 | PASS | 8.611s |
| RVLAB-AGENT-06 | INCOMPLETE receipt cannot become successful proof | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.053s |
| RVLAB-AGENT-07 | Repository changes while verification runs: receipt refused | PASS/0 | PASS | 0 | PASS | 3.004s |
| RVLAB-AGENT-08 | PR Intelligence bound to same changed-scope verification | PASS/0 | PASS | 0 | PASS | 6.51s |
| RVLAB-AGENT-09 | MCP verify then derived tools without duplicate verification | PASS/0 | PASS | 0 | PASS | 10.994s |
| RVLAB-AGENT-10 | MCP cached receipt rejected as stale after edit | PASS/0 | PASS | 0 | PASS | 10.929s |
| RVLAB-AGENT-11 | Repair lifecycle ends in a bound PASS receipt | PASS/0 | PASS | 0 | PASS | 22.238s |
| RVLAB-AGENT-12 | Waiver shortcut rejected by integrity boundary | FAIL/0 | FAIL | 0 | PASS | 14.591s |
| RVLAB-AGENT-13 | Two differently named clones produce identical receipt identity | PASS/0 | PASS | 0 | PASS | 13.648s |
| RVLAB-AGENT-14 | Staged index-only mutation invalidates receipt | PASS/0 | PASS | 0 | PASS | 7.932s |
| RVLAB-AGENT-15 | Tampered receipt refused by integrity check | PASS/0 | PASS | 0 | PASS | 7.087s |
| RVLAB-SIMPLECOV-01 | Native SimpleCov JSON normalization and verification | PASS/0 | PASS | 0 | PASS | 6.72s |
| RVLAB-SIMPLECOV-02 | Native SimpleCov JSON low changed-line coverage failure | PASS/0 | PASS | 0 | PASS | 6.691s |
| RVLAB-SIMPLECOV-03 | Native SimpleCov JSON malformed format fail-closed | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.965s |
| RVLAB-ANALYZER-03 | Large legitimate RSpec suite succeeds within safety bounds | PASS/0 | PASS | 0 | PASS | 6.651s |
| RVLAB-ANALYZER-04 | Oversized RSpec output exceeds limit and fails closed without crash | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 5.129s |
| RVLAB-FINDING-01 | Finding message safety and normalization hardening | FAIL/1 | FAIL | 1 | PASS | 3.23s |
| RVLAB-VERSION-01 | Unknown tool version canonicalization | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 3.173s |
| RVLAB-DETERMINISM-02 | 20 consecutive executions determinism campaign | PASS/0 | PASS | 0 | PASS | 128.669s |
| RVLAB-FRESH-01 | Fresh receipt remains fresh | PASS/0 | PASS | 0 | PASS | 8.51s |
| RVLAB-FRESH-02 | HEAD change makes receipt stale | PASS/0 | PASS | 0 | PASS | 8.743s |
| RVLAB-FRESH-03 | Index change makes receipt stale | PASS/0 | PASS | 0 | PASS | 8.484s |
| RVLAB-FRESH-04 | Worktree change makes receipt stale | PASS/0 | PASS | 0 | PASS | 8.297s |
| RVLAB-FRESH-05 | Config change makes receipt stale | PASS/0 | PASS | 0 | PASS | 8.42s |
| RVLAB-FRESH-06 | Baseline change makes receipt stale | PASS/0 | PASS | 0 | PASS | 8.529s |
| RVLAB-FRESH-07 | Waivers change makes receipt stale | PASS/0 | PASS | 0 | PASS | 8.505s |
| RVLAB-ENV-01 | Same environment remains fresh | PASS/0 | PASS | 0 | PASS | 8.547s |
| RVLAB-ENV-02 | RailVerdiv version drift makes stale | PASS/0 | PASS | 0 | PASS | 8.462s |
| RVLAB-ENV-03 | Ruby version drift makes stale | PASS/0 | PASS | 0 | PASS | 8.577s |
| RVLAB-ENV-04 | Analyzer version drift makes stale | PASS/0 | PASS | 0 | PASS | 8.386s |
| RVLAB-ENV-05 | Missing analyzer makes unavailable | PASS/0 | PASS | 0 | PASS | 8.796s |
| RVLAB-ENV-06 | Analyzer probe failure makes unavailable | PASS/0 | PASS | 0 | PASS | 8.531s |
| RVLAB-ENV-07 | Irrelevant tool does not invalidate | PASS/0 | PASS | 0 | PASS | 8.778s |
| RVLAB-ENV-08 | Analyzer ordering does not affect digest | PASS/0 | PASS | 0 | PASS | 8.431s |
| RVLAB-PORTABLE-01 | Portable clone 1 remains fresh | PASS/0 | PASS | 0 | PASS | 8.776s |
| RVLAB-PORTABLE-02 | Portable clone 2 remains fresh | PASS/0 | PASS | 0 | PASS | 8.711s |
| RVLAB-PORTABLE-03 | Portable clone 3 remains fresh | PASS/0 | PASS | 0 | PASS | 8.591s |
| RVLAB-PORTABLE-04 | Portable clone 4 remains fresh | PASS/0 | PASS | 0 | PASS | 8.65s |
| RVLAB-MCP-PROTOCOL-01 | MCP JSON-RPC protocol conformance | PASS/0 | PASS | 0 | PASS | 0.621s |
| RVLAB-MCP-PARITY-01 | MCP receipt parity with CLI | PASS/0 | PASS | 0 | PASS | 15.352s |
| RVLAB-MCP-HANDOFF-01 | MCP handoff round-trip matches CLI decision | PASS/0 | PASS | 0 | PASS | 9.64s |
| RVLAB-MCP-HANDOFF-02 | MCP handoff tamper detection | PASS/0 | PASS | 0 | PASS | 6.805s |
| RVLAB-MCP-HANDOFF-03 | MCP handoff size containment | PASS/0 | PASS | 0 | PASS | 7.042s |
| RVLAB-MCP-FINDINGS-01 | MCP findings tools return real evidence | PASS/0 | PASS | 0 | PASS | 8.526s |
| RVLAB-MCP-FRESH-REAL-01 | MCP evidence freshness after dirty edits | PASS/0 | PASS | 0 | PASS | 31.034s |
| RVLAB-REPAIR-BOUNDARY-01 | Real fix succeeds | PASS/0 | PASS | 0 | PASS | 8.608s |
| RVLAB-REPAIR-BOUNDARY-02 | Waiver injection fails | PASS/0 | PASS | 0 | PASS | 7.974s |
| RVLAB-REPAIR-BOUNDARY-03 | Baseline injection fails | PASS/0 | PASS | 0 | PASS | 8.613s |
| RVLAB-REPAIR-BOUNDARY-04 | Config weakening fails | PASS/0 | PASS | 0 | PASS | 8.751s |
| RVLAB-REPAIR-BOUNDARY-05 | Fix plus boundary fails | PASS/0 | PASS | 0 | PASS | 8.449s |
| RVLAB-REPAIR-BOUNDARY-06 | RVLAB-16 fixed | PASS/0 | PASS | 0 | PASS | 8.572s |
| RVLAB-RECEIPT-13X-01 | Receipt integrity 1 | PASS/0 | PASS | 0 | PASS | 8.116s |
| RVLAB-RECEIPT-13X-02 | Receipt integrity 2 | PASS/0 | PASS | 0 | PASS | 8.376s |
| RVLAB-RECEIPT-13X-03 | Receipt integrity 3 | PASS/0 | PASS | 0 | PASS | 8.703s |
| RVLAB-RECEIPT-13X-04 | Receipt integrity 4 | PASS/0 | PASS | 0 | PASS | 8.128s |
| RVLAB-RECEIPT-13X-05 | Receipt integrity 5 | PASS/0 | PASS | 0 | PASS | 8.39s |
| RVLAB-RH-RSPEC-01 | RSpec noisy stdout isolation (RH-01) | PASS/0 | PASS | 0 | PASS | 4.748s |
| RVLAB-RH-RSPEC-02 | RSpec unexplained nonzero exit fails closed (RH-02) | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.955s |
| RVLAB-RH-RSPEC-03 | RSpec normal failed examples produce findings (RH-02 positive) | FAIL/1 | FAIL | 1 | PASS | 4.804s |
| RVLAB-RH-RSPEC-04 | RSpec missing structured report fails closed (RH-01) | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.895s |
| RVLAB-RH-RSPEC-05 | RSpec malformed structured report fails closed (RH-01) | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.866s |
| RVLAB-RH-MINITEST-01 | Minitest unexplained nonzero exit fails closed (RH-03) | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 6.136s |
| RVLAB-RH-MINITEST-02 | Minitest reporter identity bound to RailVerdict (RH-04) | PASS/0 | PASS | 0 | PASS | 6.245s |
| RVLAB-RH-SIMPLECOV-01 | SimpleCov unsupported 0.x rejected (RH-05) | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 6.438s |
| RVLAB-RH-SIMPLECOV-02 | SimpleCov deterministic missing-timestamp normalization (RH-06) | PASS/0 | PASS | 0 | PASS | 6.975s |
| RVLAB-RH-SIMPLECOV-03 | SimpleCov external absolute path rejected (RH-07) | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 6.559s |
| RVLAB-RH-SIMPLECOV-04 | SimpleCov traversal symlink escape rejected (RH-07) | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 6.82s |
| RVLAB-RH-SIMPLECOV-05 | SimpleCov external configured coverage_path rejected (RH-08) | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 6.465s |
| RVLAB-RH-ENV-01 | VerificationEnvironment bundle probe failure does NOT fallback (RH-09) | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 5.024s |
| RVLAB-RH-ENV-02 | Long analyzer timeout does not leak into version probe (RH-10) | PASS/0 | PASS | 0 | PASS | 5.039s |
| RVLAB-15-BRAKEMAN-01 | Brakeman clean scan succeeds in gate evaluation | PASS/0 | PASS | 0 | PASS | 3.815s |
| RVLAB-15-BRAKEMAN-02 | Brakeman security warning detected and fails gate | FAIL/1 | FAIL | 1 | PASS | 3.848s |
| RVLAB-15-TARGETED-01 | Changed scope triggers targeted RSpec test selection | PASS/0 | PASS | 0 | PASS | 6.217s |
| RVLAB-15-TARGETED-02 | Routes change triggers safe fallback to full test verification | PASS/0 | PASS | 0 | PASS | 5.788s |
| RVLAB-CI-01 | Change Intelligence authorization surface | PASS/0 | PASS | 0 | PASS | 7.02s |
| RVLAB-CI-02 | Change Intelligence migration signal | PASS/0 | PASS | 0 | PASS | 7.06s |
| RVLAB-CI-03 | Change Intelligence dependency signal | PASS/0 | PASS | 0 | PASS | 7.001s |
| RVLAB-CI-04 | Change Intelligence routes signal | PASS/0 | PASS | 0 | PASS | 7.181s |
| RVLAB-CI-05 | Change Intelligence multi-surface change | PASS/0 | PASS | 0 | PASS | 6.957s |
| RVLAB-CI-06 | Change Intelligence preserves failure gate | FAIL/1 | FAIL | 1 | PASS | 7.28s |
| RVLAB-CI-07 | Change Intelligence renamed model evidence | PASS/0 | PASS | 0 | PASS | 6.858s |
| RVLAB-CI-08 | Change Intelligence ambiguous generic service | PASS/0 | PASS | 0 | PASS | 6.742s |
| RVLAB-CI-09 | Change Intelligence project sensitive area | PASS/0 | PASS | 0 | PASS | 4.452s |
| RVLAB-CI-10 | Change Intelligence initializer configuration surface | PASS/0 | PASS | 0 | PASS | 7.326s |
| RVLAB-POL-01 | Policy authorization change requires RSpec and Brakeman | PASS/0 | PASS | 0 | PASS | 2.059s |
| RVLAB-POL-02 | Policy targeted execution against FULL requirement stays INCOMPLETE | PASS/2 | PASS | 2 | PASS | 2.125s |
| RVLAB-POL-03 | Policy migration change executes FULL verification scope | PASS/0 | PASS | 0 | PASS | 2.155s |
| RVLAB-POL-04 | Policy dependency change requires BundlerAudit evidence | PASS/0 | PASS | 0 | PASS | 1.486s |
| RVLAB-POL-05 | Policy changed-lines coverage above minimum satisfies | PASS/0 | PASS | 0 | PASS | 0.674s |
| RVLAB-POL-06 | Policy changed-lines coverage below minimum violates | PASS/1 | PASS | 1 | PASS | 0.575s |
| RVLAB-POL-07 | Policy missing coverage evidence stays INCOMPLETE | PASS/2 | PASS | 2 | PASS | 0.646s |
| RVLAB-POL-08 | Policy new critical finding violates while existing debt does not | FAIL/1 | FAIL | 1 | PASS | 8.565s |
| RVLAB-POL-09 | Policy existing debt alone satisfies the new-findings rule | PASS/0 | PASS | 0 | PASS | 7.969s |
| RVLAB-POL-10 | Policy high-risk change requires human review without approval | PASS/3 | PASS | 3 | PASS | 4.105s |
| RVLAB-POL-11 | Policy mirrors gate byte-for-byte under a 1.6 configuration | PASS/0 | PASS | 0 | PASS | 4.261s |
| RVLAB-POL-12 | Policy CLI and MCP project the identical envelope | PASS/0 | PASS | 0 | PASS | 10.098s |
| RVLAB-POL-13 | Policy change after receipt surfaces as drift | PASS/0 | PASS | 0 | PASS | 12.345s |
| RVLAB-POL-14 | Policy repeated runs are byte-identical | PASS/0 | PASS | 0 | PASS | 8.138s |
| RVLAB-POL-15 | Policy contradictory configuration fails closed | UNKNOWN/2 | UNKNOWN | 2 | PASS | 4.082s |
| RVLAB-WF-01 | Review packet projects gate policy and recovery | PASS/0 | PASS | 0 | PASS | 4.019s |
| RVLAB-WF-02 | Human observation binds to fresh state | UNKNOWN/0 | UNKNOWN | 0 | PASS | 0.996s |
| RVLAB-WF-03 | Observation over moved state is stale | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.942s |
| RVLAB-WF-04 | Tampered observation is invalid | UNKNOWN/2 | UNKNOWN | 2 | PASS | 1.078s |
| RVLAB-WF-05 | Unknown author is untrusted | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.965s |
| RVLAB-WF-06 | Workflow closes ready on clean change | PASS/0 | PASS | 0 | PASS | 4.166s |
| RVLAB-WF-07 | Workflow blocked by gate on deterministic failure | FAIL/1 | FAIL | 1 | PASS | 3.937s |
| RVLAB-WF-08 | Workflow review pending never upgrades via observation | PASS/3 | PASS | 3 | PASS | 1.093s |
| RVLAB-WF-09 | Repair loop closes successful after fix | WARN/0 | WARN | 0 | PASS | 11.762s |
| RVLAB-WF-10 | MCP review packet matches CLI envelope | PASS/0 | PASS | 0 | PASS | 10.063s |
| RVLAB-WF-11 | Repeated review evaluations are identical | PASS/0 | PASS | 0 | PASS | 8.149s |
| RVLAB-WF-12 | Unmapped changed files get a focus pointer | PASS/0 | PASS | 0 | PASS | 0.65s |
| DEEP-CLI-SARIF-01 | doctor rejects sarif with a usage error | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.505s |
| DEEP-CLI-SARIF-02 | baseline create rejects sarif with a usage error | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.429s |
| DEEP-CLI-SARIF-03 | findings rejects sarif with a usage error | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.423s |
| DEEP-CLI-SARIF-04 | explain rejects sarif before finding resolution | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.448s |
| DEEP-CLI-SARIF-05 | repair build rejects sarif before packet assembly | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.499s |
| DEEP-CLI-SARIF-06 | check keeps a machine-readable sarif document | UNKNOWN/0 | UNKNOWN | 0 | PASS | 6.781s |
| DEEP-CLI-INV-01 | investigate preview dispatches and returns manifests | UNKNOWN/0 | UNKNOWN | 0 | PASS | 6.799s |
| DEEP-CLI-CONSOLE-01 | console check prints the passing gate word | UNKNOWN/0 | UNKNOWN | 0 | PASS | 6.749s |
| DEEP-CLI-CFG-01 | unknown configuration version is incomplete | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 0.489s |
| DEEP-CLI-CFG-02 | unknown configuration key is incomplete | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 0.505s |
| DEEP-CLI-CFG-03 | mistyped configuration value is incomplete | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 0.429s |
| DEEP-CLI-CONSOLE-02 | console check prints the failing gate word | UNKNOWN/1 | UNKNOWN | 1 | PASS | 6.442s |
| DEEP-CLI-CFG-04 | unparseable configuration is incomplete | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 0.486s |
| DEEP-CLI-CFG-05 | disabled-but-required analyzer invariant is incomplete | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 0.464s |
| DEEP-CLI-INT-01 | SIGINT during verification exits 130 with a real interrupted verdict | INCOMPLETE/130 | INCOMPLETE | 130 | PASS | 1.65s |
| DEEP-CLI-EXP-01 | explain round-trips a real introduced finding | UNKNOWN/0 | UNKNOWN | 0 | PASS | 12.837s |
| DEEP-CLI-HO-01 | handoff create and inspect round-trip on the CLI | UNKNOWN/0 | UNKNOWN | 0 | PASS | 7.045s |
| DEEP-GIT-SPLIT-01 | staged-unstaged placement swap invalidates the receipt | PASS/0 | PASS | 0 | PASS | 8.23s |
| DEEP-SEL-LIB-01 | lib change with an RSpec candidate runs targeted without crashing | PASS/0 | PASS | 0 | PASS | 6.239s |
| DEEP-SEL-LIB-02 | lib change without a candidate falls back to full without crashing | PASS/0 | PASS | 0 | PASS | 5.796s |
| DEEP-SEL-LIB-03 | lib change with a Minitest candidate runs targeted without crashing | PASS/0 | PASS | 0 | PASS | 7.445s |
| DEEP-SEL-SEM-01 | breaking a lib file without updating its test fails the targeted run | FAIL/1 | FAIL | 1 | PASS | 6.533s |
| DEEP-REUSE-01 | static evidence reuses while dynamic tests execute fresh | PASS/0 | PASS | 0 | PASS | 15.139s |
| DEEP-CI-SURF-01 | policy and migration changes report detected surfaces and high risk | PASS/0 | PASS | 0 | PASS | 6.531s |
| DEEP-CI-SURF-02 | session-like lib file is an authentication near-miss with an unmapped pointer | PASS/0 | PASS | 0 | PASS | 7.062s |
| DEEP-CI-SURF-03 | secret-adjacent initializer reports a mixed security surface at critical risk | PASS/0 | PASS | 0 | PASS | 6.648s |
| DEEP-CI-RISK-01 | per-surface risk override lowers the verdict level | PASS/0 | PASS | 0 | PASS | 6.959s |
| DEEP-CI-RISK-02 | named sensitive area fires its own signal and reason | PASS/0 | PASS | 0 | PASS | 6.84s |
| DEEP-CI-RISK-03 | unknown risk surface name is ignored without breaking the verdict | PASS/0 | PASS | 0 | PASS | 6.852s |
| DEEP-CI-UNMAP-09 | 9 unsurfaced paths yield one bounded unmapped entry | PASS/0 | PASS | 0 | PASS | 6.555s |
| DEEP-CI-UNMAP-10 | 10 unsurfaced paths yield one bounded unmapped entry | PASS/0 | PASS | 0 | PASS | 6.938s |
| DEEP-CI-UNMAP-11 | 11 unsurfaced paths yield one bounded unmapped entry | PASS/0 | PASS | 0 | PASS | 6.827s |
| DEEP-CI-UNMAP-MIX | mapped change outranks the capped unmapped pointer | PASS/0 | PASS | 0 | PASS | 6.739s |
| DEEP-CI-SURF-04 | dependency manifest change reports the dependencies surface | PASS/0 | PASS | 0 | PASS | 6.977s |
| DEEP-POL-COV-84 | coverage just below the minimum violates the requirement | PASS/1 | PASS | 1 | PASS | 0.617s |
| DEEP-POL-COV-85 | coverage just above the minimum satisfies the requirement | PASS/0 | PASS | 0 | PASS | 0.711s |
| DEEP-POL-COV-86 | coverage below a raised minimum violates the requirement | PASS/1 | PASS | 1 | PASS | 0.613s |
| DEEP-POL-COV-ABOVE | coverage clearly above the minimum satisfies the requirement | PASS/0 | PASS | 0 | PASS | 0.633s |
| DEEP-POL-HIGH-01 | introduced high-severity finding violates the forbid rule | PASS/1 | PASS | 1 | PASS | 0.671s |
| DEEP-POL-UNAVAIL-01 | required analyzer that never executes is unavailable, never violated | PASS/2 | PASS | 2 | PASS | 0.61s |
| DEEP-POL-CFG-01 | zero coverage minimum is a configuration error, not a rule | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.505s |
| DEEP-POL-CFG-02 | over-range coverage minimum is a configuration error, not a rule | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.436s |
| DEEP-POL-CFG-03 | mistyped coverage minimum is a configuration error, not a rule | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.455s |
| DEEP-POL-HANDOFF-01 | strengthened policy after handoff is re-evaluated, never reused stale | PASS/2 | PASS | 2 | PASS | 11.453s |
| DEEP-POL-COMPAT-01 | oldest config version applies no new rules | PASS/0 | PASS | 0 | PASS | 4.188s |
| DEEP-POL-001 | migration under human review stays pending after a bound observation | PASS/3 | PASS | 3 | PASS | 16.071s |
| DEEP-REPAIR-001 | waiver and analyzer disablement are not repair | PASS/0 | PASS | 0 | PASS | 26.04s |
| DEEP-MCP-001 | projections do not rerun analyzers and stale state is refused | PASS/0 | PASS | 0 | PASS | 13.959s |
| DEEP-REV-001 | incomplete policy evidence closes as blocked by evidence | PASS/2 | PASS | 2 | PASS | 0.68s |
| DEEP-MCP-PAR-01 | CLI and MCP project the same policy packet and verification | PASS/0 | PASS | 0 | PASS | 2.316s |
| DEEP-MCP-SES-01 | sibling project sessions stay isolated from each other | PASS/0 | PASS | 0 | PASS | 17.614s |
| DEEP-CLI-FIND-01 | findings exits zero on a completed failing gate | UNKNOWN/0 | UNKNOWN | 0 | PASS | 6.585s |
| DEEP-CLI-DOC-01 | doctor console renders the doctor banner | UNKNOWN/0 | UNKNOWN | 0 | PASS | 1.742s |
| DEEP-MCP-EXP-01 | explain and investigate previews work over MCP | PASS/0 | PASS | 0 | PASS | 8.584s |
| DEEP-POL-HUMAN-02 | medium-risk change triggers its human review requirement | PASS/3 | PASS | 3 | PASS | 4.321s |
| DEEP-ADV-01 | handoff verify rejects a traversal path | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.513s |
| DEEP-ADV-02 | receipt verify rejects an absolute outside path | UNKNOWN/2 | UNKNOWN | 2 | PASS | 0.464s |
| DEEP-CI-M01 | authentication change reports the authentication surface | PASS/0 | PASS | 0 | PASS | 6.599s |
| DEEP-CI-M02 | database change reports the database surface | PASS/0 | PASS | 0 | PASS | 6.8s |
| DEEP-CI-M03 | public_api change reports the public_api surface | PASS/0 | PASS | 0 | PASS | 6.888s |
| DEEP-CI-M04 | background_jobs change reports the background_jobs surface | PASS/0 | PASS | 0 | PASS | 6.44s |
| DEEP-CI-M05 | controllers change reports the controllers surface | PASS/0 | PASS | 0 | PASS | 6.912s |
| DEEP-CI-M06 | models change reports the models surface | PASS/0 | PASS | 0 | PASS | 6.833s |
| DEEP-CI-M07 | views change reports the views surface | PASS/0 | PASS | 0 | PASS | 6.555s |
| DEEP-CI-M08 | mailers change reports the mailers surface | PASS/0 | PASS | 0 | PASS | 7.039s |
| DEEP-CI-M09 | storage change reports the storage surface | PASS/0 | PASS | 0 | PASS | 6.63s |
| DEEP-CI-M10 | initializers change reports the initializers surface | PASS/0 | PASS | 0 | PASS | 6.704s |
| DEEP-CI-M11 | configuration change reports the configuration surface | PASS/0 | PASS | 0 | PASS | 6.907s |
| DEEP-CI-M12 | test_infrastructure change reports the test_infrastructure surface | PASS/0 | PASS | 0 | PASS | 7.056s |
| DEEP-CI-M13 | shared_infrastructure change reports the shared_infrastructure surface | PASS/0 | PASS | 0 | PASS | 6.615s |
| DEEP-CI-M14 | routes change reports the routes surface | PASS/0 | PASS | 0 | PASS | 6.343s |
| DEEP-GIT-EMPTY-01 | unborn HEAD fails closed with an incomplete verdict | INCOMPLETE/2 | INCOMPLETE | 2 | PASS | 4.971s |

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
| DEEP-CLI-SARIF-01 | UNKNOWN/2 | UNKNOWN | PASS |
| DEEP-CLI-SARIF-02 | UNKNOWN/2 | UNKNOWN | PASS |
| DEEP-CLI-SARIF-03 | UNKNOWN/2 | UNKNOWN | PASS |
| DEEP-CLI-SARIF-04 | UNKNOWN/2 | UNKNOWN | PASS |
| DEEP-CLI-SARIF-05 | UNKNOWN/2 | UNKNOWN | PASS |
| DEEP-CLI-CFG-01 | INCOMPLETE/2 | INCOMPLETE | PASS |
| DEEP-CLI-CFG-02 | INCOMPLETE/2 | INCOMPLETE | PASS |
| DEEP-CLI-CFG-03 | INCOMPLETE/2 | INCOMPLETE | PASS |
| DEEP-CLI-CFG-04 | INCOMPLETE/2 | INCOMPLETE | PASS |
| DEEP-CLI-CFG-05 | INCOMPLETE/2 | INCOMPLETE | PASS |
| DEEP-CLI-INT-01 | INCOMPLETE/130 | INCOMPLETE | PASS |
| DEEP-POL-CFG-01 | UNKNOWN/2 | UNKNOWN | PASS |
| DEEP-POL-CFG-02 | UNKNOWN/2 | UNKNOWN | PASS |
| DEEP-POL-CFG-03 | UNKNOWN/2 | UNKNOWN | PASS |
| DEEP-ADV-01 | UNKNOWN/2 | UNKNOWN | PASS |
| DEEP-ADV-02 | UNKNOWN/2 | UNKNOWN | PASS |

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

## Aggregation Integrity

Integrity errors: NO.
Uncovered catalog capabilities: none.

## Final Verdict

VALIDATION PASS
