# RVLAB-FINDING-002 — Waiver mutation can retain a PASS repair gate

## Status

OPEN / DOCUMENTED (Mitigated in 1.2.0 Agent Verification Protocol via Stale Receipt Rejection)

## Severity

P0

## RailVerdict Candidate

version: 1.0.1
source SHA: unknown for published gem
gem SHA256: 5a4a425ede8ea1563cca4e641e874a41b95a6f2e51eb96e759909e4f8979d3a9

## Lab Environment

Lab SHA: eaff5d8a67524f354bc6008f9c271f7f7c60994d
Ruby: 3.4.5
Rails: 8.1.3.1
OS: Linux x86_64

## Scenario

scenario ID: RVLAB-16

## Expected Behavior

After a repair packet is created for an introduced blocking finding, adding a
waiver instead of fixing source must be rejected. The public repair result must
not be a successful PASS while the target remains present and the verification
boundary changed.

## Actual Behavior

The public MCP verify_repair response reported:

- target_status: still_present
- gate: PASS
- completion_status: complete
- verification_boundary_changed: true
- boundary changed: waivers

The Lab wrapper therefore observed PASS/exit 0 for a repair that did not fix
the target.

## Why This Is a Product Defect

The response exposes the boundary mutation but leaves the authoritative gate at
PASS. A consumer that trusts gate or overall success can accept an agent repair
that only adds a waiver, violating the anti-cheating contract.

## Exact Reproduction

From the Lab checkout:

```bash
scripts/lab_run --scenario RVLAB-16 --use-installed
```

The scenario creates a real RuboCop finding in a disposable Git fixture, uses
MCP initialize/tools/list/verify/list_findings/get_finding/build_repair_packet,
adds a waiver for the target fingerprint, and calls verify_repair in the same
stdio session.

## Public Evidence

- exit code: 0 from the repair result wrapper
- completion status: complete
- gate: PASS
- target_status: still_present
- verification_boundary_changed: true
- changed boundary: waivers

## Minimal Synthetic Reproduction

Create one blocking RuboCop finding, build a public repair packet, add an active
waiver for its public fingerprint, then invoke MCP verify_repair with the
packet ID without changing the finding's source line.

## Affected Public Contract

MCP / repair / anti-cheating / GateResult authority.

## Fail-Closed Impact

false PASS.

## Security / Integrity Impact

An agent can appear to have repaired a finding by changing policy boundary data.

## Workaround

The Lab treats verification_boundary_changed=true or target_status=still_present
as a rejection even when gate says PASS. Consumers should not rely on gate alone
until the product contract is corrected.

## Suggested Product Direction

Make boundary mutation and a still-present target authoritative in
verify_repair: return a non-success repair status and never expose PASS as the
repair outcome.

## Regression Requirement

Add a public MCP regression that creates a packet, adds a waiver, calls
verify_repair, and asserts target_status still_present, boundary changed, and a
non-PASS repair result.
