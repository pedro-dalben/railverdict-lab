# D00 — Reconciliation (read-only, 2026-09-06 UTC)

Campaign branch: `lab/deep-cert-1.8.2`, created from
`1b371d11b0ebc0ab0eef0a37b16eef560311e97d` (== `origin/lab/1.8-agent-workflow`).
Both worktrees were clean at branch time. No merges, publishes, or branch-protection
changes were made. Product repo untouched (still on `docs/g6-canonical-sha`).

## 1. Product refs (`pedro-dalben/RailVerdict`)

| Object | Observed | Note |
|---|---|---|
| `master` | `4db5cb6` (merge of `program/g3-validation`, docs only) | Goal doc cited `4e3e8bf`; that SHA is absent locally — superseded before D00. |
| Local checkout | `docs/g6-canonical-sha` = `9b7d99e` | 1 file vs master: `docs/program/final-report.md` (canonical SHA refresh). Docs only. |
| `v1.8.2` | annotated tag `000d11e` → merge `89a4673` (PR #15) | `VERSION = "1.8.2"`. `rev-parse v1.8.2` yields the tag object; commit identity is `89a4673`. |
| `v1.8.1` | `e2ad188` (merge, PR #14) | `v1.8.1..v1.8.2` lib delta is the real candidate delta (see §3). |
| `v1.8.2..HEAD` | docs/program + ROADMAP only (375+/5-) | No code delta; docs-only drift must not be presented as binary origin (D01 pins the tag). |
| Product CI | green (`34032602099`, master push, 2026-09-06) | No product-side blocker. |

## 2. Lab refs (`pedro-dalben/railverdict-lab`)

| Object | Observed | Note |
|---|---|---|
| `origin/main` | `9de2ac2` (merge lab/1.4-handoff) | Matches goal doc. |
| Local `main` | `29b9636` (stale, behind `origin/main`) | Must NOT be used as campaign base. Left untouched. |
| Campaign base | `1b371d1` == `origin/lab/1.8-agent-workflow` | Contains `ff18894` (1.7-policy) by ancestry — verified via `merge-base --is-ancestor`. |
| PR #17 (`lab/1.7-policy`, `ff18894`) | OPEN | Ancestor of #18, not a competing content fork. |
| PR #18 (`lab/1.8-agent-workflow`, `1b371d1`) | OPEN | Campaign base; includes #17 by ancestry. |
| Lab CI (`RailVerdict Lab 2.0`) | RED on all 14 matrix jobs (runs `34009428609`, `34009419719`, …) | Root cause: `gem fetch rail_verdict -v 1.8.2` → `Could not find a valid gem` — 1.8.2 is **unpublished** while `lab/candidate.yml` declares `mode: published`. Infra failure, not a product verdict. |
| CI side effect | `railverdict-pr.yml` pushes `lab/04…`, `lab/05…` fixture branches to origin | Recorded; campaign must not depend on those remote fixture branches (see §5). |

Base decision: campaign proceeds on `lab/deep-cert-1.8.2` from `1b371d1`
(1.7 + 1.8 + 1.8.2 lab coverage in one ancestry line). No remote merge required.

## 3. Candidate code delta `v1.8.1..v1.8.2` (product)

`change_intelligence.rb` (+15, unmapped-focus pointer), `pr_intelligence.rb`,
`reporters/console.rb`, `version.rb`, `CHANGELOG.md`, `Gemfile.lock`,
`test/test_change_intelligence.rb` (+17). Matches the 1.8.2 changelog claim
(bounded `unmapped` entry, ≤10 paths, ranked last, no risk inflation).
`v1.7.0..v1.8.2 -- lib` additionally shows the 1.8 workflow surface
(`review_packet.rb`, `review_observation.rb`, `workflow_receipt.rb`,
`reporters/review.rb`, `mcp/tools/*review*`, `+repair verify`, CLI +226).

## 4. Catalog and identity manifests

- `lab/scenarios.yml`: **173** `- id:` entries, **zero duplicate IDs**
  (`sort | uniq -d` empty). Header is stale: `catalog_version: '4.1'` +
  description cites `(1.4 … 132 scenarios)`.
- `lab/candidate.yml`: `catalog_version: '5.0'`, `scenario_catalog_version: '5.0'`,
  candidate `mode: published`, `gem_version: 1.8.2`, `tag: v1.8.2`,
  `gem_sha256: 23f68175…0aa3b3`, **`source_sha: HEAD`** (not an identity — D01 must pin).
- Local `RailVerdict/rail_verdict-1.8.2.gem` SHA-256 = `23f68175…0aa3b3`:
  **matches** `candidate.yml`. Local-build certification path is viable (D01).
- `README.md` stale (candidate 1.2.0, "81 scenarios"); `docs/` retains 1.2.0
  certification artifacts. CI matrix (14 categories) predates policy/review/mcp
  interface families present in the catalog.
- Decision: preserve all 173 scenario IDs (migrate + strengthen, never delete);
  fix catalog metadata in D03; do not quote "132", "713 tests", or "all PASS"
  as current facts.

## 5. Fixture-branch semantics (confirmed read-only)

`LabSupport.clone_fixture(repo_root=ROOT=lab repo, work_dir, branch:)` —
`scripts/lab_support.rb:72-89`:

1. `git clone file://<lab-repo>`, 2. rename current branch to `main`,
3. `git checkout -b <setup["branch"]>` — creates a **new nominal branch from
   campaign HEAD**, never checks out the remote fixture branch of the same name.

Real fixture branches (`lab/01-clean-change`, `lab/02-existing-debt`, …,
owned by `scripts/create_branches`) exist but the runner ignores their content.
`setup.branch` is therefore a label, and every scenario's truth comes from
`operations` applied onto campaign HEAD. D02/LAB-12 must make this explicit and
prove effective fixture content (base commit + tree digest recorded per attempt).

## 6. Oracle risks revalidated statically (`scripts/lab_oracle`, D02 to reproduce)

- `expected_for().compact` + special-keys loop (`next unless special.key?(key) ||
  product.key?(key)`, lines 144–146): an expectation whose key is absent from the
  result is **silently unevaluated** — false PASS risk. CONFIRMED by reading.
- Counts fallback (lines 68–75): missing `comparison.counts` is derived from
  `findings` states; absent evidence degrades toward zero. CONFIRMED by reading.
- `product_result`-vs-envelope fallback (lines 50–60) plus `readiness`-inferred
  completion: synthetic envelopes can stand in for the real response. D02 must prove.
- Oracle stdout = pretty JSON + `\n✅ [LAB ORACLE PASS] …` (lines 197–200):
  a file capturing stdout is multi-document, not one valid JSON document. D02 must prove.
- `validate_catalog!` checks `schema_version == "2.0"` + unique IDs + required keys
  but does not reject unknown expectation keys (typo'd expectation → never evaluated
  unless D02's declared/evaluated accounting lands). D02 must prove.
- Runner reuse/collision, `LabSupport.json` parse-errors, aggregate
  empty-selection/skip/capability accounting: carried as D02 obligations
  (LAB-05/06/07/11), not yet reproduced.

## 7. Environment (this machine)

`ruby 3.4.5`, `bundler 4.0.16`, `git 2.43.0`, `gem 3.6.9`,
`candidate.yml` pins ruby 3.4.5 / rails 8.1.3.1 / analyzers
(rubocop 1.89.0, rspec 3.13.6, minitest 6.0.6, simplecov 1.0,
bundler-audit 0.9.3, brakeman 8.0.6). Full environment lock in D01.

## 8. D00 pass/fail and handoff

- PASS to open the campaign: base preserves all capabilities
  (1.7-policy ancestry + 1.8-workflow + 1.8.2 pointer scenarios on one line);
  no broken branch absorbed (local stale `main` explicitly excluded);
  every goal-doc pin re-checked and corrected above.
- Known external blocker: `rail_verdict 1.8.2` unpublished on RubyGems →
  distribution status starts at `DISTRIBUTION_UNVERIFIED`; Lab CI red for that
  reason. Independent nodes proceed via local-gem candidate (D01).
- Program-claim hygiene: G3/G4 dataset and adoption statements observed in
  `docs/program/` are out of scope for this verdict and are not adopted as facts.
- Next: D01 pins the immutable candidate (tag `v1.8.2` → commit `89a4673`,
  gem SHA `23f68175…0aa3b3`, isolated install, full environment lock).
