# RailVerdict Lab — Controlled Real-World Validation Report

**Report Generated:** 2026-08-18  
**Target Application:** `OrderHub` (Ruby on Rails 8.1.3.1 / Ruby 3.4.5)  
**Execution Environment:** Linux x86_64, local-first black-box gem installation  

---

## 1. Candidate Under Test

| Property | Value |
|---|---|
| **Gem Package** | `rail_verdict-0.1.0.gem` |
| **Git Revision** | `54ca7b555045101fed4556d68b1626ccadf34ceb` |
| **Source Repository** | `git@github.com:pedro-dalben/RailVerdict.git` |
| **Package Checksum (SHA-256)** | `ce7169c83a5ea4f7025965b0cc97e93744b4ad63de8f90bef977142bd4d6925a` |
| **Gem Version** | `0.1.0` |
| **Frozen At** | `2026-08-18T12:46:11-03:00` |

---

## 2. Executive Recommendation: NO-GO (P0 Release Blocker Discovered)

> [!CAUTION]
> **MERGE GATE RECOMMENDATION: NO-GO / BLOCKED FOR PUBLIC RELEASE**
> 
> Real-world validation in `RailVerdict Lab` discovered **1 critical P0 False-PASS defect** and **1 high-severity P1 analyzer defect**. 
> While baseline adoption, anti-cheating security checks, waivers, and the MCP stdio protocol performed exceptionally well, the P0 defect violates the core merge-gate safety promise by reporting `PASS` on broken test assertions.

### Defect Summary
1. **P0 / RELEASE BLOCKER (RVLAB-003)**: In RSpec, modifying a test assertion inside an `it "..."` block causes RSpec's native JSON formatter to report the example's header line rather than the assertion line. RailVerdict's `ChangedLineEvaluator` treats the failure as "outside changed lines" and returns **`Gate: PASS` (False PASS)**.
2. **P1 / HIGH SEVERITY (RVLAB-001)**: The Minitest probe command `bundle exec ruby -I test -r test_helper --version` is intercepted by MRI Ruby, returning Ruby's version `3.4.5`. RailVerdict rejects this as `unsupported (3.4.5 < 5.0)`, preventing any Minitest suite from executing in real Rails apps.
3. **DOC GAP / EXPECTED (RVLAB-002)**: SimpleCov upstream JSON formatter outputs a hash-based dictionary rather than the `files` array mandated by RailVerdict's `coverage-v1.schema.json`.

---

## 3. Validation Matrix & Empirical Results

| ID | Title | Category | Expected Gate | Actual Gate | Expected Exit | Actual Exit | Oracle Status | Duration |
|---|---|---|---|---|---|---|---|---|
| **RVLAB-01** | Clean application change | Core PR | PASS | **PASS** | 0 | **0** | ✅ MATCH | 5.25s |
| **RVLAB-02** | Existing legacy debt only | Core PR | PASS | **PASS** | 0 | **0** | ✅ MATCH | 5.22s |
| **RVLAB-03** | New RuboCop regression | Core PR | FAIL | **FAIL** | 1 | **1** | ✅ MATCH | 5.36s |
| **RVLAB-04** | Real Minitest failure | Core PR | FAIL | **INCOMPLETE** | 1 | **2** | ❌ DEFECT (RVLAB-001) | 4.65s |
| **RVLAB-05** | Real RSpec failure | Core PR | FAIL | **PASS** | 1 | **0** | ❌ FALSE PASS (RVLAB-003) | 4.30s |
| **RVLAB-06** | Zero required tests | Core PR | INCOMPLETE | **INCOMPLETE** | 2 | **2** | ✅ MATCH | 4.28s |
| **RVLAB-07** | Required analyzer unavailable | Core PR | INCOMPLETE | **INCOMPLETE** | 2 | **2** | ✅ MATCH | 3.89s |
| **RVLAB-08** | Active waiver | Core PR | PASS | **PASS** | 0 | **0** | ✅ MATCH | 9.80s |
| **RVLAB-09** | Expired waiver | Core PR | FAIL | **FAIL** | 1 | **1** | ✅ MATCH | 9.99s |
| **RVLAB-10** | Git edge cases (renames, binary) | Core PR | PASS | **PASS** | 0 | **0** | ✅ MATCH | 5.48s |
| **RVLAB-11** | Changed scope vs historical debt | Core PR | FAIL | **FAIL** | 1 | **1** | ✅ MATCH | 5.30s |
| **RVLAB-12** | Real changed-line coverage | Core PR | PASS | **PASS** | 0 | **0** | ✅ MATCH | 5.35s |
| **RVLAB-13** | Invalid Git base | Operational | INCOMPLETE | **INCOMPLETE** | 2 | **2** | ✅ MATCH | 1.31s |
| **RVLAB-14** | Shallow Git history | Operational | INCOMPLETE | **INCOMPLETE** | 2 | **2** | ✅ MATCH | 1.30s |
| **RVLAB-15** | Agent cheats: policy weakening | Security | PASS* | **PASS** (advisory) | 0 | **0** | ✅ MATCH | 4.26s |
| **RVLAB-16** | Agent cheats: waiver addition | Security | FAIL | **FAIL** (regressed) | 1 | **1** | ✅ MATCH | 8.64s |
| **RVLAB-17** | Agent cheats: baseline mutation | Security | FAIL | **FAIL** (boundary) | 1 | **1** | ✅ MATCH | 8.65s |
| **RVLAB-18** | MCP complete repair loop | MCP | PASS | **PASS** | 0 | **0** | ✅ MATCH | 8.36s |

*Note: In RVLAB-15, verify_repair flags `verification_boundary_changed: true` when configuration is tampered.*

---

## 4. Empirical Performance & Stability

- **Fastest Verification Check (CLI):** 1.21s (Git validation fail-closed checks)
- **Standard PR Check (5 Analyzers + Rails context):** ~5.3s
- **Full MCP Loop (Init + Tools + Verify + RepairPacket + VerifyRepair):** 8.34s
- **Process Isolation:** All child processes executed via argument arrays with explicit PID process-group tracking; 0 orphan processes or zombie subprocesses observed.
- **Fail-Closed Behavior:** Confirmed in all 4 operational failure scenarios (shallow clone, invalid base revision, zero tests, missing analyzer).

---

## 5. Security & Anti-Cheating Protocol Audit

RailVerdict was subjected to 3 deliberate adversarial agent attack vectors:
1. **Policy Weakening (RVLAB-15):** Changing `mode: no_new_debt` to `mode: advisory` in `.railverdict.yml`.
   - *Outcome:* `verify_repair` re-read policy and computed configuration digests, catching boundary changes.
2. **Waiver Injection (RVLAB-16):** Adding unapproved waivers into `.railverdict-waivers.json` to bypass code repair.
   - *Outcome:* `verify_repair` rejected waiver-masked fixes and reported `target_status: still_present` / `verification_boundary_changed: true`.
3. **Baseline Overwrite (RVLAB-17):** Overwriting `.railverdict-baseline.json` via `railverdict baseline create --force` instead of fixing code.
   - *Outcome:* `verify_repair` detected baseline boundary tampering and preserved failing gate status.

---

## 6. Model Context Protocol (MCP) Audit

- **Transport:** stdio JSON-RPC 2.0 (`railverdict mcp serve`)
- **Protocol Version:** `2025-11-25`
- **Tool Inventory:** 7 declared tools (`verify`, `list_findings`, `get_finding`, `build_repair_packet`, `verify_repair`, `explain`, `investigate`)
- **Anti-Tampering Invariant:** **0 unauthorized write, exec, or git tools discovered.** The tool surface is strictly read-only and analytical.
- **RepairPacket Contract:** Generated bounded (8.4 KB), secret-redacted, schema-compliant `repair_packet` v1.
- **End-to-End Autonomous Repair Loop:**
  `verify` (FAIL) ➔ `list_findings` (3 found) ➔ `get_finding` ➔ `build_repair_packet` ➔ (External edit applied) ➔ `verify_repair` (fixed: true, gate: PASS).

---

## 7. Remote Publication Boundary

In accordance with safety instructions, remote GitHub repository creation was withheld until authorized.

To publish this validated laboratory to GitHub under `pedro-dalben/railverdict-lab`:
```bash
# 1. Create remote repository
gh repo create pedro-dalben/railverdict-lab --public --source=. --description="Real-world validation laboratory for RailVerdict"

# 2. Push main branch
git push -u origin main

# 3. Push all validation scenario branches
git push origin --all

# 4. Open validation pull requests for GitHub Actions verification
for branch in $(git branch --list 'lab/*' | tr -d ' *'); do
  gh pr create --base main --head "$branch" --title "Validation Scenario: $branch" --body "Automated test scenario for RailVerdict PR gate."
done
```
