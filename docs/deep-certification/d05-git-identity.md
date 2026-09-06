# D05 — Git, identity, receipts (candidate 1.8.3, 2026-09-06 UTC)

## 1. Legacy execution on 1.8.3

agent 16/16 · freshness 9/9 · portability 4/4 · receipt 5/5 ·
environment 10/10. Dimension coverage verified in the catalog: HEAD, index,
worktree, config, baseline, waivers, ruby, analyzer versions, missing
analyzer, probe failure, irrelevant-tool freshness, ordering stability,
clone portability, receipt integrity, and the deterministic TOCTOU race
(RVLAB-AGENT-07: `wait_gate` barrier + mid-run mutation → issuance refused
with `repository_changed_during_verification`).

## 2. New proof: placement is identity (DEEP-GIT-SPLIT-01, PASS)

Staged-vs-unstaged content swapped between index and worktree changes both
digests; the pre-swap receipt verifies `stale` with both `index_changed`
and `worktree_changed` reasons. Required a new `stage` setup operation and
a `receipt_swap_flow`; both unit-tested. A manual probe first confirmed the
two dimensions are tracked separately before the scenario was pinned.

## 3. Obligation deltas

- O-GIT-SCOPE stays partial: rename/unicode/binary/split-placement proven;
  empty-tree verification and copy-detection remain untested (minor, carried).
- O-GIT-IDENTITY-RECEIPT stays covered (44 legacy scenarios + 1 DEEP).
- Catalog: 191 scenarios.
