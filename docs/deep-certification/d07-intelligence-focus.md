# D07 — Rails change intelligence and review focus (candidate 1.8.3)

## 1. Legacy execution

change_intelligence 10/10 on 1.8.3.

## 2. Source truth

`ChangeSurfaces::SURFACES` defines 18 surfaces (code) vs 19 claimed in
1.6 docs (B-003, documentation-only, recorded without version bump).
Each surface carries evidence paths and an explicit tier
(detected/inferred/mixed); focus caps every entry at 10 paths.

## 3. New scenarios (11, all PASS)

- SURF-01: policy + migration → detected/detected, models untouched,
  HIGH, focus [authorization, migration].
- SURF-02: `lib/session_report.rb` → authentication near-miss (unchanged)
  plus one trailing unmapped pointer.
- SURF-03: secret-named initializer → mixed security surface, CRITICAL.
  (A `config/master.key` fixture was abandoned: Rails gitignore swallows it
  and the empty commit proved nothing — initializers match the same
  matchers with no secret content.)
- SURF-04: comment-only Gemfile touch → dependencies changed, MEDIUM.
- RISK-01: `review.risk` override (authorization→medium) caps the verdict
  at MEDIUM with `configured: true`.
- RISK-02: named `financial` glob area fires
  `project_sensitive_path_changed:financial` and joins HIGH reasons.
- RISK-03: unknown surface name in `review.risk` is ignored (exit 0,
  defaults apply) — documented lenient behavior, not a defect.
- UNMAP-09/10/11: unmapped path counts 9/10/10 — the 10-path cap proven at
  the boundary; pure-unmapped changes stay LOW (no risk inflation).
- UNMAP-MIX: policy + 12 unsurfaced files → [authorization, unmapped(10)],
  HIGH from the mapped surface only.

## 4. Focus recall corpus (analysis, not a gate)

| Change | Label | Focus top-3 | Hit |
|---|---|---|---|
| policy file | authorization | [authorization] | @1 |
| migration | migration | [migration] | @1 |
| both | authorization, migration | [authorization, migration] | @2 |
| model comment touch | models | [database] | miss |

The miss is deliberate ranking semantics, verified in
`review_focus`: non-sensitive items fully covered by higher-ranked items
are skipped to shrink the review search space (models is non-sensitive;
database is sensitive and ordered first). `surfaces.models.changed`
remains true — focus is a risk-ordered deduped subset, never the exhaustive
surface list. Reviewers needing completeness must read `surfaces`, not
`review_focus`. Utility limitation stated, invariants (deterministic order,
bounds, no hallucinated paths) kept.

## 5. Obligations

O-CI-RISK, O-CI-UNMAPPED, O-CI-FOCUS → covered. O-CI-SURFACES stays partial:
6 of 18 surfaces proven with tiers (authorization, migration, models,
security, authentication-nearmiss, dependencies); per-surface
positive/near-miss/mixed for the remaining 12 is carried as known
incompleteness. Catalog: 207 scenarios.
