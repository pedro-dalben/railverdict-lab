# RailVerdict Lab — Validation Plan

## 1. Overview and Objectives
RailVerdict Lab is a controlled, real-world validation framework designed to test the RailVerdict release candidate against a real Rails application (`OrderHub`) using:
- Real Rails application domain (Customer, Order, Product, Invoice)
- Real Git history, branches, pull requests
- Real analyzer processes (RuboCop, RSpec, Minitest, SimpleCov, bundler-audit)
- Built and installed `rail_verdict` gem (black-box validation)
- Real baseline and `no_new_debt` policies
- Real changed-scope diff evaluation
- Real RepairPacket creation and security checks (anti-cheating verification)
- Real Model Context Protocol (MCP) stdio client loop

## 2. Core Validation Philosophy
- **Unit/integration tests** prove implementation behavior.
- **RailVerdict Lab** proves product behavior.
- **Failures are evidence**: Discovered defects are recorded with minimal reproductions and severity classification without modifying RailVerdict source code.

## 3. Scenario Matrix

| ID | Title | Category | Expected Gate | Expected Exit | Description |
|---|---|---|---|---|---|
| RVLAB-01 | Clean application change | Core PR | PASS | 0 | Harmless new model method with tests |
| RVLAB-02 | Existing legacy debt only | Core PR | PASS | 0 | Touch unrelated code; baseline shields legacy debt |
| RVLAB-03 | New RuboCop regression | Core PR | FAIL | 1 | Introduce new deterministic RuboCop finding in changed scope |
| RVLAB-04 | Real Minitest failure | Core PR | FAIL | 1 | Failing test assertion normalized and caught |
| RVLAB-05 | Real RSpec failure | Core PR | FAIL | 1 | Failing RSpec example normalized and caught |
| RVLAB-06 | Zero required tests | Core PR | INCOMPLETE | 2 | Suite runs but 0 tests executed (fail-closed) |
| RVLAB-07 | Required analyzer unavailable | Core PR | INCOMPLETE | 2 | Required tool fails to spawn or is missing |
| RVLAB-08 | Active waiver | Core PR | PASS | 0 | Finding waived with active UTC expiration |
| RVLAB-09 | Expired waiver | Core PR | FAIL | 1 | Expired waiver fails to suppress finding |
| RVLAB-10 | Git edge cases | Core PR | PASS | 0 | Renames, spaces, bracket paths, binary files |
| RVLAB-11 | Changed scope vs historical debt | Core PR | FAIL | 1 | Regressions in PR block; historical debt does not |
| RVLAB-12 | Real changed-line coverage | Core PR | PASS | 0 | SimpleCov coverage artifact parsed for changed lines |
| RVLAB-13 | Invalid Git base | Operational | INCOMPLETE | 2 | Invalid base fails closed without guessing |
| RVLAB-14 | Shallow Git history | Operational | INCOMPLETE | 2 | Missing merge-base history fails closed |
| RVLAB-15 | Agent cheats: policy weakening | Security | N/A | N/A | verify_repair detects configuration mutation |
| RVLAB-16 | Agent cheats: waiver addition | Security | N/A | N/A | verify_repair detects waiver mutation |
| RVLAB-17 | Agent cheats: baseline mutation | Security | N/A | N/A | verify_repair detects baseline mutation |
| RVLAB-18 | MCP complete repair loop | MCP | PASS | 0 | Full stdio repair loop from verify to verify_repair |
| RVLAB-19 | Agent trial readiness | Future | N/A | N/A | Preparation for autonomous agent repair session |

## 4. Oracle Design
The Lab Oracle (`scripts/lab_oracle`) is completely external to RailVerdict internals. It parses the public JSON contract emitted by `railverdict check --format json` and asserts that actual behavior matches the formal scenario expectations.
