# D10 — CLI/MCP/CI parity (candidate 1.8.3)

## 1. Harness gap fixed

The MCP protocol conformance list pinned 12 tools, silently omitting the
1.7/1.8 additions (`get_engineering_policy`, `get_review_packet`,
`verify_review_observation`, `create_workflow_receipt`). Extended to all
16 with a unit test. (Same never-silent class as D02 H-01.)

## 2. Parity proofs (all PASS)

- DEEP-MCP-PAR-01: on one green state, CLI `policy` vs
  `get_engineering_policy` (decision + policy_digest equal), CLI
  `review show` vs `get_review_packet` (packet_id equal — deterministic
  canonical core), CLI `check` vs `verify` + `list_findings` (gate +
  finding count equal). First attempt caught a real ordering rule:
  projection tools answer `verification_required` until `verify` runs in
  the same session — the flow now verifies first.
- DEEP-MCP-SES-01: two sessions over equivalent clones verify
  independently; mutating project A leaves project B's receipt fresh.
  (First draft used a fresh client for the final receipt and got
  `verification_required` from its empty cache — the session must stay
  open; corrected.)
- DEEP-MCP-001 (D09): zero-rerun projections + stale refusal.

## 3. CI

- Matrix extended 14 → 25 categories (policy, review, intelligence,
  freshness, receipt, portability, environment, selection, repair,
  hardening, security were never scheduled).
- Exit/status propagation already correct (`exit "$status"`, `collect`
  always runs, artifacts uploaded on error). CI stays red until 1.8.3 is
  published: the local-build SHA gate cannot pass on a CI-built gem
  (non-reproducible outer tar). Distribution decision recorded in D13.

## 4. Obligations

O-MCP-POLICY, O-MCP-REVIEW, O-MCP-SESSION → covered. O-MCP-PROTOCOL
covered. O-MCP-EXPLAIN-INVESTIGATE stays partial (advisory preview paths
only). Catalog: 226.
