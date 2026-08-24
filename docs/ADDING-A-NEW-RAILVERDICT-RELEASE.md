# Adding and Certifying a New RailVerdict Release in the Lab

This guide documents the standardized process for maintainers to evaluate, certify, and benchmark a new candidate release of RailVerdict (e.g., `1.3.0` or `2.0.0`) using the independent Lab.

---

## 1. Build and Freeze the Candidate Gem

1. Clone or pull the target RailVerdict release commit from the product repository:
   ```bash
   cd /path/to/RailVerdict
   git checkout <release-tag-or-sha>
   gem build rail_verdict.gemspec
   ```
2. Compute the exact SHA-256 digest of the built `.gem` artifact:
   ```bash
   sha256sum rail_verdict-<version>.gem
   ```
3. Copy the artifact into `artifacts/rail_verdict-<version>.gem` in the Lab repository.

---

## 2. Update Candidate Manifest

Edit `lab/candidate.yml`:

```yaml
candidate:
  mode: published
  gem_name: rail_verdict
  gem_version: "<new-version>"
  repository: "https://github.com/pedro-dalben/RailVerdict.git"
  source_sha: "<exact-commit-sha>"
  tag: "v<new-version>"
  gem_sha256: "<exact-64-char-hex-sha256>"
  frozen_at: "<iso-8601-timestamp>"
  scenario_catalog_version: "2.0"
  capabilities:
    cli: [init, doctor, check, pr, findings, baseline, explain, investigate, repair, receipt, mcp]
    mcp: [initialize, "tools/list", verify, list_findings, get_finding, build_repair_packet, verify_repair, explain, investigate, get_verification_receipt, get_pr_intelligence]
    pr_intelligence: true
    per_analyzer_timeout: true
    repository_state_identity: true
    verification_receipts: true
    snapshot_guard: true
    native_simplecov: true
```

---

## 3. Map Public Contracts

Create `docs/contracts/RAILVERDICT-<version>-CONTRACT-MATRIX.md`:
* Enumerate all CLI commands, flags, schemas, exit codes, MCP tools, and integrity boundaries.
* Identify any new features, breaking changes, or deprecations.

---

## 4. Author New Scenarios

If the new release introduces new capabilities or hardening:
1. Add new scenario definitions to `lab/scenarios.yml`.
2. Follow the Lab taxonomy (`RVLAB-<CATEGORY>-<NN>`).
3. Ensure every scenario specifies exact `expected_gate`, `expected_completion`, `expected_exit`, and semantic assertions.

---

## 5. Execute Lab Infrastructure Self-Tests

Verify that the Lab itself is functional and all negative assertion tests pass:

```bash
bundle exec rake test
```

---

## 6. Run the Release Campaign

Run the full battery against the candidate artifact:

```bash
scripts/lab_run --all --artifact artifacts/rail_verdict-<version>.gem
```

Generate the empirical summary report:

```bash
scripts/lab_collect
```

Inspect `docs/VALIDATION_REPORT.md` and `artifacts/lab-run-summary.json`.

---

## 7. Document Findings & Issue Certification Report

1. If any discrepancy or contract violation is found, document it under `docs/findings/RVLAB-<version>-FINDING-XXX.md`.
2. Produce `docs/RAILVERDICT-<version>-CERTIFICATION.md` with the final verdict:
   * `CERTIFIED`
   * `CERTIFIED_WITH_NON_BLOCKING_FINDINGS`
   * `NOT_CERTIFIED`
