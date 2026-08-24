# RailVerdict 1.2.0 — Public Contract Matrix

This document defines the authoritative contract matrix for `rail_verdict 1.2.0`. Every public capability across CLI, JSON, SARIF, MCP, Repository State Identity, Verification Receipts, Repair, and Analyzers is documented below with its public interface, expected output, exit semantics, determinism guarantees, fail-closed guarantees, and corresponding Lab validation scenario.

---

## 1. Core Verification & CLI

| Capability | Public interface | Expected output | Exit semantics | Deterministic? | Fail-closed? | Lab scenario |
|---|---|---|---|---|---|---|
| Initialize Config | `railverdict init [--config PATH]` | Writes default `.railverdict.yml` with valid configuration-v1.5 schema | `0` on success, `2` on failure/path error | Yes (stable default YAML) | Yes (refuses path escape) | `RVLAB-INSTALL-01` |
| Doctor Diagnostics | `railverdict doctor [--config PATH]` | Structured diagnostic report of environment, Ruby, Git, analyzers, and config | `0` on healthy, `2` on operational error | Yes | Yes (surfaces missing tools) | `RVLAB-INSTALL-02` |
| Standard Verification (Console) | `railverdict check [--config PATH]` | Human-readable console summary of gate, analyzer runs, findings, and debt | `0` (PASS/WARN), `1` (FAIL), `2` (INCOMPLETE) | Yes (stable finding order) | Yes (missing evidence -> INCOMPLETE/2) | `RVLAB-CHECK-01` |
| JSON Output Mode | `railverdict check --format json` | Single JSON document on stdout matching `result-v1.schema.json`; diagnostics on stderr | `0` (PASS/WARN), `1` (FAIL), `2` (INCOMPLETE) | Yes (excluding volatile duration) | Yes (invalid stdout fails closed) | `RVLAB-CHECK-02` |
| SARIF 2.1.0 Output Mode | `railverdict check --format sarif` | Pure GateResult projection into SARIF 2.1.0 JSON on stdout; diagnostics on stderr | `0` (PASS/WARN), `1` (FAIL), `2` (INCOMPLETE) | Yes (rule & result determinism) | Yes (mirrors gate exit) | `RVLAB-CHECK-03` |
| Findings Subcommand | `railverdict findings [--format console\|json]` | List of normalized findings with fingerprint, analyzer, path, line, message | `0` on success, `2` on operational error | Yes (sorted by fingerprint) | Yes | `RVLAB-CHECK-04` |
| Baseline Creation | `railverdict baseline create [--output PATH]` | Versioned `baseline-v1` file containing fingerprints of existing findings | `0` on success, `2` on operational error | Yes (deterministic ordering & unknown versions) | Yes (atomic write) | `RVLAB-BASELINE-01` |
| Baseline Debt Shielding | `railverdict check` with baseline | Existing baseline findings classified as `existing` (not blocking); no-new-debt policy | `0` if no introduced debt, `1` if new debt | Yes (stable fingerprint comparison) | Yes (invalid baseline -> INCOMPLETE) | `RVLAB-BASELINE-02` |
| Active Waivers | `railverdict check` with active waiver | Matching finding suppressed under `waivers-v1` with valid unexpired UTC date | `0` (PASS/WARN) if all blockers waived | Yes (exact fingerprint match) | Yes (unmatched waiver ignored) | `RVLAB-WAIVER-01` |
| Expired Waivers | `railverdict check` with expired waiver | Expired waiver ignored; finding remains blocking introduced debt | `1` (FAIL) | Yes | Yes (expired waiver cannot suppress) | `RVLAB-WAIVER-02` |
| Changed Scope Verification | `railverdict check --changed --base REV` | Verification filtered to files changed between merge-base(REV, HEAD) and worktree | `0` (PASS), `1` (FAIL), `2` (INCOMPLETE) | Yes (deterministic Git diff) | Yes (missing/shallow base -> INCOMPLETE) | `RVLAB-GIT-01` |
| Tracked Deletions Preservation | `railverdict check --changed --base REV --format json` | `git.changed_files` retains deleted tracked files across single & multiple commits | `0` (PASS), `1` (FAIL) | Yes | Yes (deletion included in provenance) | `RVLAB-GIT-02` |
| Git Path Edge Cases | `railverdict check --changed --base REV` | Safe handling of spaces, renames, binary files, symlinks, unicode paths | `0` (PASS), `1` (FAIL) | Yes (NUL-delimited status parsing) | Yes | `RVLAB-GIT-03` |
| Per-Analyzer Timeout | `.railverdict.yml` `timeout_seconds: N` | Analyzer killed after monotonic timeout; `execution_status: timed_out` | `2` (INCOMPLETE when analyzer required) | Yes | Yes (timed out analyzer never PASS) | `RVLAB-FAILCLOSED-01` |
| Explain Finding | `railverdict explain <id\|fingerprint> [--preview-context]` | Structured explanation (rule details, snippet, optional AI); preview mode offline | `0` on success, `2` on missing finding/error | Yes | Yes (AI never mutates GateResult) | `RVLAB-CHECK-05` |
| Investigate Findings | `railverdict investigate [--limit N] [--preview-context]` | Triage and investigation manifest for top findings | `0` on success, `2` on error | Yes | Yes (bounded budgets & secret redaction) | `RVLAB-CHECK-06` |

---

## 2. PR Intelligence 1.2.0

| Capability | Public interface | Expected output | Exit semantics | Deterministic? | Fail-closed? | Lab scenario |
|---|---|---|---|---|---|---|
| PR Intelligence CLI | `railverdict pr [--base REV] [--format console\|json]` | PR Intelligence document matching `pr-intelligence-v1.schema.json` | `0` (PASS/WARN), `1` (FAIL), `2` (INCOMPLETE) | Yes (stable projection) | Yes (GateResult authority preserved) | `RVLAB-PR-01` |
| GateResult Authority | `railverdict pr` | `gate` in PR document strictly matches underlying `GateResult.gate` | Mirrored from GateResult | Yes | Yes (PR Intelligence never contradicts gate) | `RVLAB-PR-02` |
| Debt Classification | `railverdict pr` | Accurate counts of introduced, existing, and resolved findings in changed scope | Mirrored from GateResult | Yes (exact fingerprint diffing) | Yes | `RVLAB-PR-03` |
| PR Stable Projection | `PRIntelligence.stable_projection` | Stable subset excluding volatile duration/seeds for deterministic hashing/receipts | N/A (data contract) | Yes (100% deterministic digest) | Yes | `RVLAB-PR-04` |

---

## 3. Repair & Anti-Cheating Protocol

| Capability | Public interface | Expected output | Exit semantics | Deterministic? | Fail-closed? | Lab scenario |
|---|---|---|---|---|---|---|
| RepairPacket Creation | `railverdict repair <id\|fingerprint> [--output PATH]` | Deterministic `repair-packet-v1` document with `packet_id = sha256:<64hex>` | `0` on success, `2` on error | Yes (bounded ≤256 KiB, canonical ID) | Yes (target must exist) | `RVLAB-REPAIR-01` |
| Genuine Source Repair | MCP `verify_repair` with valid fix | `target_status: fixed`, `gate: PASS`, `completion_status: complete` | `0` (PASS) | Yes | Yes | `RVLAB-REPAIR-02` |
| Unrepaired Finding | MCP `verify_repair` without edits | `target_status: still_present`, `gate: FAIL` | `1` (FAIL) | Yes | Yes | `RVLAB-REPAIR-03` |
| Altered/Regressed Fix | MCP `verify_repair` with buggy fix | `target_status: changed` or `regressed`, `gate: FAIL` | `1` (FAIL) | Yes | Yes | `RVLAB-REPAIR-04` |
| Moved Finding | MCP `verify_repair` with shifted line | `target_status: moved` (tracked by fingerprint) | `1` (FAIL) | Yes | Yes | `RVLAB-REPAIR-05` |
| Anti-Cheating: Waiver Injection | MCP `verify_repair` + waiver added | `verification_boundary_changed: true`, `target_status: still_present`, non-PASS repair | `1` or `2` (non-success) | Yes (boundary change detected) | Yes (waiver does NOT count as fixed) | `RVLAB-REPAIR-06` |
| Anti-Cheating: Baseline Mutation | MCP `verify_repair` + baseline edited | `verification_boundary_changed: true`, non-PASS repair | `1` or `2` (non-success) | Yes (baseline digest mismatch) | Yes (baseline mutation rejected) | `RVLAB-REPAIR-07` |
| Anti-Cheating: Config Weakening | MCP `verify_repair` + config weakened | `verification_boundary_changed: true`, non-PASS repair | `1` or `2` (non-success) | Yes (config digest mismatch) | Yes (config weakening rejected) | `RVLAB-REPAIR-08` |

---

## 4. Model Context Protocol (MCP) 1.2.0

| Capability | Public interface | Expected output | Exit semantics | Deterministic? | Fail-closed? | Lab scenario |
|---|---|---|---|---|---|---|
| MCP Server Stdio | `railverdict mcp serve` | JSON-RPC 2.0 stdio stream implementing MCP 2025-11-25 protocol | `0` on clean shutdown | Yes | Yes (bounded framing) | `RVLAB-MCP-01` |
| `initialize` & `tools/list` | JSON-RPC `tools/list` | List of 9 public read-only tools matching schema | `0` | Yes | Yes | `RVLAB-MCP-02` |
| `verify` Tool | MCP `tools/call` `verify` | Full GateResult JSON + embedded Verification Receipt v1 | `0` (success in JSON-RPC) | Yes | Yes (returns complete/incomplete) | `RVLAB-MCP-03` |
| `list_findings` & `get_finding` | MCP `tools/call` | Returns cached findings; reads from memory without rerunning analyzers | `0` | Yes | Yes | `RVLAB-MCP-04` |
| `build_repair_packet` | MCP `tools/call` | Constructs RepairPacket v1 for specified finding | `0` | Yes | Yes | `RVLAB-MCP-05` |
| `verify_repair` | MCP `tools/call` | Executes verification and compares against RepairPacket boundary | `0` | Yes | Yes (boundary tracking) | `RVLAB-MCP-06` |
| `explain` & `investigate` | MCP `tools/call` | Returns diagnostic/manifest explanations | `0` | Yes | Yes (bounded/redacted) | `RVLAB-MCP-07` |
| `get_verification_receipt` | MCP `tools/call` | Returns cached Verification Receipt v1 without rerunning analyzers | `0` | Yes | Yes (`verification_required` if stale) | `RVLAB-MCP-08` |
| `get_pr_intelligence` | MCP `tools/call` | Returns cached PR Intelligence v1 for changed-scope verification | `0` | Yes | Yes (`verification_required` if stale) | `RVLAB-MCP-09` |
| Single Verification Execution | MCP workflow: `verify` then derived tools | Analyzers executed exactly once; derived tools read cached result | `0` | Yes | Yes (verified via analyzer invocation counts) | `RVLAB-MCP-10` |
| Stale Cache Refusal | MCP tools after repo mutation | Derived tools return `verification_required` / error when repo state changed | `0` (MCP error payload) | Yes | Yes (stale cache never silently reused) | `RVLAB-MCP-11` |

---

## 5. Repository State Identity v1 & Verification Receipts v1

| Capability | Public interface | Expected output | Exit semantics | Deterministic? | Fail-closed? | Lab scenario |
|---|---|---|---|---|---|---|
| State Identity Calculation | `RailVerdict::RepositoryState.capture` | `digest = sha256:<64hex>` over HEAD, index, worktree delta, config/baseline/waivers | N/A (internal engine / public receipt) | Yes (path-independent, mtime-insensitive) | Yes (fails closed on Git failure) | `RVLAB-STATE-01` |
| State Identity Determinism | Repeated capture on unchanged repo | `identity_A == identity_B` across repeated runs and multiple clones | N/A | Yes (100% deterministic) | Yes | `RVLAB-STATE-02` |
| Mutation: HEAD | Commit made | State identity changes | N/A | Yes | Yes | `RVLAB-STATE-03` |
| Mutation: Index | File staged (`git add`) | State identity changes (distinguishes staged from unstaged) | N/A | Yes | Yes | `RVLAB-STATE-04` |
| Mutation: Worktree | Tracked file modified | State identity changes (per-path content hash) | N/A | Yes | Yes | `RVLAB-STATE-05` |
| Mutation: Untracked | Untracked file added | State identity changes | N/A | Yes | Yes | `RVLAB-STATE-06` |
| Mutation: Config | `.railverdict.yml` edited | State identity changes (`configuration_digest`) | N/A | Yes | Yes | `RVLAB-STATE-07` |
| Mutation: Baseline | Baseline file edited | State identity changes (`baseline_digest`) | N/A | Yes | Yes | `RVLAB-STATE-08` |
| Mutation: Waiver | Waiver file edited | State identity changes (`waivers_digest`) | N/A | Yes | Yes | `RVLAB-STATE-09` |
| Invariance: mtime | `touch` tracked file | State identity unchanged | N/A | Yes (content-addressed) | Yes | `RVLAB-STATE-10` |
| Invariance: Path Independence | Clone repo to alternate directory | State identity matches byte-for-byte | N/A | Yes (excludes absolute paths) | Yes | `RVLAB-STATE-11` |
| Receipt Creation | `railverdict receipt create [--format json]` | Emits `verification-receipt-v1` document with deterministic `receipt_id` | `0` (PASS/WARN), `1` (FAIL), `2` (INCOMPLETE) | Yes (volatile data excluded) | Yes (guarded execution) | `RVLAB-RECEIPT-01` |
| Receipt Schema & IDs | `railverdict receipt create` | Conforms to `verification-receipt-v1.schema.json`; `receipt_id` equals canonical SHA-256 | Mirrored from GateResult | Yes | Yes | `RVLAB-RECEIPT-02` |
| Receipt Freshness: Fresh | `railverdict receipt verify <file>` | `status: fresh`, `reasons: []`, original gate & completion status | `0` (fresh PASS/WARN), `1` (fresh FAIL) | Yes | Yes | `RVLAB-RECEIPT-03` |
| Receipt Freshness: Stale Source | Modify source after receipt | `status: stale`, `reasons: ["worktree_changed"]` | `2` (stale -> exit 2) | Yes | Yes (stale receipt cannot pass) | `RVLAB-RECEIPT-04` |
| Receipt Freshness: Stale Index | Stage change after receipt | `status: stale`, `reasons: ["index_changed"]` | `2` | Yes | Yes | `RVLAB-RECEIPT-05` |
| Receipt Freshness: Stale Commit | Move HEAD after receipt | `status: stale`, `reasons: ["head_changed"]` | `2` | Yes | Yes | `RVLAB-RECEIPT-06` |
| Receipt Freshness: Stale Policy | Change config/baseline/waiver | `status: stale`, `reasons: ["configuration_changed"|"baseline_changed"|"waivers_changed"]` | `2` | Yes | Yes | `RVLAB-RECEIPT-07` |
| Receipt Freshness: Invalid | Corrupt receipt JSON / bad ID | `status: invalid`, `reasons: ["receipt_integrity_failed"|"receipt_malformed"|...]` | `2` | Yes | Yes (tampered receipt rejected) | `RVLAB-RECEIPT-08` |
| Receipt Freshness: Unavailable | Corrupt Git repo state | `status: unavailable`, `reasons: ["repository_state_unavailable:..."]` | `2` | Yes | Yes | `RVLAB-RECEIPT-09` |
| Snapshot Guard (Mid-Verification Mutation) | Concurrent mutation during verification | Refuses receipt issuance; `status: unavailable`, `reason: repository_changed_during_verification` | `2` (INCOMPLETE / unavailable) | Yes | Yes (fail-closed snapshot protection) | `RVLAB-RECEIPT-10` |

---

## 6. Analyzer Hardening & Evidence Normalization

| Capability | Public interface | Expected output | Exit semantics | Deterministic? | Fail-closed? | Lab scenario |
|---|---|---|---|---|---|---|
| RuboCop Integration | `railverdict check` | Executes `rubocop --format json`; normalizes offenses, rule IDs, and lines | `0` (clean), `1` (offenses) | Yes | Yes | `RVLAB-ANALYZER-01` |
| RuboCop Malformed JSON | Fake/corrupt RuboCop output | `execution_status: parse_failed` or `malformed`, `gate: INCOMPLETE` | `2` (INCOMPLETE) | Yes | Yes (no crash; non-empty message) | `RVLAB-ANALYZER-02` |
| RuboCop Missing Binary | Binary missing / exit 127 | `execution_status: unavailable`, `gate: INCOMPLETE` | `2` (INCOMPLETE) | Yes | Yes (`failure.message must be non-empty`) | `RVLAB-ANALYZER-03` |
| RSpec Integration | `railverdict check` | Executes `rspec --format json`; normalizes failures, pending, and counts | `0` (pass), `1` (fail) | Yes | Yes | `RVLAB-ANALYZER-04` |
| RSpec Large Output Safety | Real RSpec suite with large JSON (e.g. 5k examples) | Successfully parses and completes verification without truncation | `0` (pass) or `1` (fail) | Yes (up to 16 MiB bound) | Yes | `RVLAB-ANALYZER-05` |
| RSpec Oversized Truncation | RSpec output exceeding 16 MiB bound | Controlled `truncated` AnalyzerResult, `gate: INCOMPLETE`, no crash | `2` (INCOMPLETE) | Yes | Yes (truncated JSON never parsed as PASS) | `RVLAB-ANALYZER-06` |
| Minitest Integration | `railverdict check` | Executes `minitest-reporter-v1`; normalizes assertions, failures, errors | `0` (pass), `1` (fail) | Yes | Yes | `RVLAB-ANALYZER-07` |
| Minitest Zero Tests | Empty test suite | `execution_status: incomplete`, `failure: {code: "zero_tests"}`, `gate: INCOMPLETE` | `2` (INCOMPLETE) | Yes | Yes (zero tests fails closed) | `RVLAB-ANALYZER-08` |
| bundler-audit Clean/Advisories | `railverdict check` | Extracts JSON payload even if informational notices precede JSON | `0` (clean), `1` (vulnerable) | Yes | Yes | `RVLAB-ANALYZER-09` |
| bundler-audit Notice Prepending | Notices before JSON payload | Robustly extracts and validates JSON; suppresses noise from finding message | `0` or `1` | Yes | Yes | `RVLAB-ANALYZER-10` |
| SimpleCov Native JSON | `simplecov` with `simplecov_json_formatter` JSON | Normalizes native format (path normalization, ignored->nil, line arrays) to canonical coverage | `0` (pass), `1` (low coverage) | Yes (deterministic file sorting) | Yes | `RVLAB-SIMPLECOV-01` |
| SimpleCov Legacy Format | `simplecov` with `coverage-v1` JSON | Normalizes legacy format; backward compatible | `0` (pass), `1` (low coverage) | Yes | Yes | `RVLAB-SIMPLECOV-02` |
| SimpleCov Changed-Line Coverage | `check --changed` + native SimpleCov | Calculates coverage on changed lines against normalized native evidence | `0` (meets threshold), `1` (below) | Yes | Yes | `RVLAB-SIMPLECOV-03` |
| SimpleCov Malformed / Stale / Missing | Bad coverage file / outside freshness window | `execution_status: malformed|stale|unavailable`, `gate: INCOMPLETE` | `2` (INCOMPLETE) | Yes | Yes (unreliable coverage fails closed) | `RVLAB-SIMPLECOV-04` |
| Finding Message Hardening: Nil/Empty | Analyzer returns empty or whitespace message | Normalized to `"<analyzer> reported a finding without a message"` | `0` or `1` | Yes (guaranteed non-empty UTF-8) | Yes (prevents ArgumentError crashes) | `RVLAB-FINDING-01` |
| Finding Message Hardening: ANSI & Control | Analyzer returns ANSI colors, null bytes, control chars | Stripped and sanitized; clean valid UTF-8 emitted | `0` or `1` | Yes | Yes (valid JSON emitted) | `RVLAB-FINDING-02` |
| Finding Message Hardening: Invalid UTF-8 | Analyzer returns broken byte sequences | Scrubbed and replaced with `\uFFFD`; valid UTF-8 emitted | `0` or `1` | Yes | Yes | `RVLAB-FINDING-03` |
| Finding Message Hardening: Oversized | Message exceeds 4096 bytes | Truncated to 4096 bytes cleanly without splitting multibyte chars | `0` or `1` | Yes | Yes | `RVLAB-FINDING-04` |
| Unknown Tool Version Canonicalization | Analyzer tool_version is nil or empty | Canonicalized to `"unknown"` across baselines, receipts, MCP cache | N/A (data contract) | Yes (prevents nondeterministic digests) | Yes | `RVLAB-VERSION-01` |

---

## 7. Multi-Fault & Determinism

| Capability | Public interface | Expected output | Exit semantics | Deterministic? | Fail-closed? | Lab scenario |
|---|---|---|---|---|---|---|
| Multi-Fault Aggregation | Multiple simultaneous failures (RuboCop + RSpec + coverage + deleted file) | All findings aggregated; no analyzer masks another; gate reflects combined FAIL | `1` (FAIL) | Yes (sorted finding order) | Yes | `RVLAB-MULTIFAULT-01` |
| Deterministic Repeated Execution | 20 consecutive identical runs | Stable fields, fingerprints, receipt IDs, and gate are 100% identical | Mirrored from GateResult | Yes (duration/timing isolated) | Yes | `RVLAB-DETERMINISM-01` |
| Package Surface & Isolated Install | Built gem installed in clean GEM_HOME | Executable, schemas, minitest reporter, library files functional from any CWD | `0` | Yes | Yes (CWD-independent build) | `RVLAB-PACKAGE-01` |
