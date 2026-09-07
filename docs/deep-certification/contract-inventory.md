# D03 — Contract inventory (2026-09-06 UTC)

Sources (all read at product `v1.8.2`, commit `89a4673` unless noted):
`lib/rail_verdict/cli.rb`, `lib/rail_verdict/mcp/{server,serializers,validators,cache}.rb`,
`lib/rail_verdict/mcp/tools/*.rb` (16 tools), `schemas/*.schema.json` (23 files,
config v1–v1.7), `lib/rail_verdict/engineering_policy.rb`,
`lib/rail_verdict/{review_observation,workflow_receipt}.rb`,
`docs/{engineering-policy,review-workflow,mcp}.md`, ADRs 0020/0021,
`docs/contracts.md` (stale, not a source), `lab/scenarios.yml` (173 scenarios).

Machine-readable obligations: `lab/deep-certification/coverage-obligations.json`
(58 obligations: 20 covered, 31 partial, 5 missing, 2 not_applicable).

## 1. Tallies that matter

- CLI dispatches 15 commands; `cli` argv scenarios invoke only
  check/policy/pr/review — the other 11 commands are reached through
  specialized interfaces that shell the real binary (verified by reading
  `product_run` call sites: init, doctor, baseline create, findings,
  repair build/verify, review show/observe, receipt create/verify,
  handoff verify, `mcp serve` via the MCP client).
- All 98 `cli` scenarios use `--format json`. Zero console scenarios.
  One SARIF scenario (`RVLAB-ACCEPT-11`, check only).
- 16 MCP tools confirmed in code; `initialize`/`tools/list`/`ping` are
  protocol ops, not tools. `docs/mcp.md` matches code on tool count;
  five field-level doc mismatches recorded in the obligations (create_handoff,
  inspect/verify_handoff shapes, verify receipt embedding).
- Requirement statuses (5), review observation statuses (5), workflow
  readiness (4), gate/completion/policy coupling — all sourced from code,
  with doc simplifications flagged (policy-FAIL-without-gate-FAIL exits 2,
  not 1; `gate_mirror` has no requirement row).

## 2. Product defect candidates found during inventory (to reproduce in D04/D10)

1. **`investigate` is dead (P0 candidate).** Advertised in USAGE (cli.rb:32),
   implemented (`command_investigate`, cli.rb:736-778), but the dispatcher
   (cli.rb:60-85) has no `when "investigate"` branch — the command exits 2 as
   unknown. Zero catalog scenarios invoke it, so the suite never caught it.
2. **`--format sarif` silently renders console** on doctor, baseline, findings,
   explain, and repair-build. `validate_format!` accepts sarif globally, but
   only `check` reaches `render_result`; the rest branch json/else-console.
3. `docs/contracts.md` CLI table is Phase-01 stale (omits 9 commands, exit 3,
   the findings/explain always-0 rules) and must not source coverage claims.

## 3. Missing obligations (zero scenarios)

`O-CLI-EXPLAIN`, `O-CLI-INVESTIGATE`, `O-CLI-HANDOFF-CREATE-INSPECT`,
`O-CLI-CONSOLE`, `O-CLI-INTERRUPT` (exit 130). Each gets DEEP scenarios in
its node, or an explicit contracted exclusion with a source-backed reason.

## 4. Thinnest partials (one scenario or one dimension)

Console/SARIF beyond check, `unavailable` observation, `blocked_by_evidence`
receipt, `new_high` forbid, coverage 84/85/86 + 0/101 + stale/missing/zero
denominator, analyzer unavailable/timeout/partial, TARGETED-insufficient pair,
policy drift after handoff, compat matrix 1.0–1.6, unmapped 9/10/11 bounds,
per-surface positive/near-miss/mixed for 19 surfaces, MCP parity for
explain/investigate/policy/review tools, lib/ RSpec+Minitest regression pair.

## 5. Handoff to executing nodes

- D04: analyzer fault matrix, config version matrix, gate truth tables;
  reproduce inventory candidates 1–2 against the locked gem first.
- D05–D06: identity/freshness races, selection mapping incl. `lib/`, reuse
  predicates with wrapper proof.
- D07: surface matrix + unmapped bounds + focus recall corpus.
- D08: requirement truth tables + exit ladder + drift + compat.
- D09: repair boundary exemplar + observation non-approval + receipt closure.
- D10: CLI/MCP parity per tool + protocol errors + CI exit preservation.
- D11: adversarial bounds, compat pins (rubocop 1.90/1.89, simplecov 1.2/1.0),
  interaction pairs, cost measures.
