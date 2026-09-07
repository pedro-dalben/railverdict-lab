# D09 — Repair, review, workflow (candidate 1.8.3)

## 1. Legacy execution

review_workflow 9/12 + repair 11/11 + repair_anti_cheating 3/3 on first
pass. The 3 review failures were stale scenario expectations exposed by
the strict oracle (never evaluated before): `review show` has no
`decision` key (packet shape asserted instead), `review complete` has no
`completion_status` (UNKNOWN token + readiness asserted). All three
repaired to real fields and re-ran PASS. This is the D02 strictness
dividend, not a product regression.

## 2. Exemplars (all PASS)

- DEEP-POL-001: check → policy (REVIEW_REQUIRED/3, req-human-review-high)
  → show → human observation (lab-computed canonical digest → valid_bound)
  → complete → review_pending/3. The note claims approval
  ("approved by senior reviewer; merge at will") and the workflow still
  pends: notes are not approvals, proven adversarially.
- DEEP-REPAIR-001: one packet, three clones — real fix successful/PASS;
  valid waiver → boundary_changed (waivers:true) with honest PASS gate,
  never successful; disabled analyzer → incomplete with boundary flags,
  never successful.
- DEEP-MCP-001: one MCP verify executes analyzers (wrapper-counted);
  findings/receipt/intelligence/policy projections add zero analysis
  subprocesses (probes only); post-mutation receipt is explicitly
  verification_required.
- DEEP-REV-001: unavailable evidence closes blocked_by_evidence/2 with
  the gate at PASS.
- DEEP-ORACLE-001: covered by the D02 battery (missing `decision` field
  rejected with a named assertion), referenced, not duplicated.

## 3. Obligations

O-REV-PACKET, O-REV-NO-APPROVAL, O-REPAIR, O-REV-RECEIPT → covered.
O-REV-OBSERVATION → covered with a carried edge (the `unavailable`
status needs unobservable state and stays untested). O-MCP-REVIEW stays
partial for D10 parity scenarios. Catalog: 222.
