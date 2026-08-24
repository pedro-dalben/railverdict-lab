# RailVerdict Lab 2.0 — Release Certification & Validation Harness

RailVerdict Lab is the authoritative, external, black-box validation and certification harness for the published `rail_verdict` gem. It rigorously exercises the public package, CLI, JSON, SARIF, stdio MCP, Git, analyzer, baseline, waiver, repair anti-cheating, verification receipts, and PR Intelligence contracts without loading RailVerdict internal classes or modifying RailVerdict source code.

The synthetic OrderHub Rails application is deliberately realistic. Broken fixtures and adversarial simulations are core components of the suite: they prove that the candidate rejects bad, invalid, or unverifiable changes instead of manufacturing success.

---

## 1. Candidate Under Test

The current frozen candidate under certification is `rail_verdict 1.2.0`:

* **Release Version**: `1.2.0`
* **Release Tag**: `v1.2.0`
* **Source Commit**: `d49c204b36fe89a6fcf5f22fd4c42978362b10d2`
* **Gem Artifact SHA-256** (published): `d8e848b1e72585b7f583a85d2a67e25b472bd1860549d1d4330c8a33104f82e9` — local build `564fe3ce8d8030898e1fe015452474ce8e21e0e3d34184fffc0de67dcb281381` has byte-identical unpacked contents; outer tar SHA differs only in packaging determinism
* **Candidate Specification**: [`lab/candidate.yml`](lab/candidate.yml)
* **Candidate Identity Manifest**: [`artifacts/candidate-identity.json`](artifacts/candidate-identity.json)
* **Release Certification Report**: [`docs/RAILVERDICT-1.2.0-CERTIFICATION.md`](docs/RAILVERDICT-1.2.0-CERTIFICATION.md)

---

## 2. Reading Validation Results

There are two distinct results in every scenario:

```text
RailVerdict Product Result: INCOMPLETE / exit 2
Lab Oracle Result:          PASS
```

* **Product Result**: What `railverdict` returned (gate, completion status, exit code, structured JSON).
* **Lab Oracle Result**: Whether `railverdict`'s behavior matched the strict public contract for that scenario. An expected `FAIL` or `INCOMPLETE` is a Lab `PASS` when the empirical output and exit code exactly match contract expectations.

| Lab Status | Meaning |
|---|---|
| `PASS` | The candidate matched the scenario's public contract. |
| `FAIL` | The candidate violated public contract; documented in `docs/findings/`. |
| `BLOCKED` | Infrastructure execution failure; prevents false certification. |
| `SKIPPED` | Candidate does not declare the capability required by the scenario. |

---

## 3. Running the Lab Locally

```bash
# Install lab dependencies
bundle install

# Run Lab infrastructure self-tests (negative tests, schema validation, oracle checks)
bundle exec rake test

# Run a single public scenario
scripts/lab_run --scenario RVLAB-01

# Run a validation category
scripts/lab_run --category acceptance
scripts/lab_run --category refusal
scripts/lab_run --category pr_intelligence
scripts/lab_run --category agent
scripts/lab_run --category simplecov

# Run full release certification campaign (81 scenarios)
scripts/lab_run --all --artifact artifacts/rail_verdict-1.2.0.gem

# Generate empirical summary report
scripts/lab_collect
```

---

## 4. Scenario Catalog & Categories (81 Scenarios)

The scenario catalog is defined in [`lab/scenarios.yml`](lab/scenarios.yml) across 14 categories:

| Category | Count | Scope & Focus |
|---|---|---|
| `acceptance` | 11 | Healthy Rails models, controllers, jobs, migrations, routes, refactors, SARIF output, explain, investigate. |
| `policy_rejection` | 3 | Real RuboCop lint violations, RSpec test failures, BundlerAudit security CVEs under `no_new_debt`. |
| `refusal` | 14 | Operational refusal (missing Gemfile, bad YAML, missing baseline, timeout, process crash, signaled, malformed). |
| `baseline_waiver` | 2 | Incremental baseline absorption and active/expired waiver lifecycle. |
| `git_changed_scope` | 1 | Preserving multi-commit tracked deletions in changed scope. |
| `analyzers` | 7 | Real analyzers, bundler-audit, large RSpec suite (>2MB), 16MB stream bounds truncation, message safety, unknown tool version. |
| `simplecov` | 3 | Native SimpleCov JSON normalization, changed-line coverage calculation, invalid coverage fail-closed. |
| `repair_anti_cheating` | 7 | MCP repair packets, source repair, policy weakening, waiver injection, baseline mutation. |
| `mcp` | 4 | MCP 2025-11-25 tool discovery, single-verify cache reuse, stale cache refusal, security isolation. |
| `agent` | 15 | Verification Receipts v1, Repository State Identity v1, freshness transitions, tamper refusal, untracked file isolation. |
| `pr_intelligence` | 4 | PR Intelligence v1 documents, signals extraction, quality delta derivation, gate alignment. |
| `determinism` | 2 | 2-run and 20-run stable verification projection invariance. |
| `package` | 1 | Isolated gem installation and CWD independence. |
| `multi_fault` | 1 | Concurrent compound analyzer failure + policy failure. |

---

## 5. Documentation & Implementation Guides

* **Public Contract Matrix**: [`docs/contracts/RAILVERDICT-1.2.0-CONTRACT-MATRIX.md`](docs/contracts/RAILVERDICT-1.2.0-CONTRACT-MATRIX.md)
* **Release Certification Report**: [`docs/RAILVERDICT-1.2.0-CERTIFICATION.md`](docs/RAILVERDICT-1.2.0-CERTIFICATION.md)
* **Rails App Adoption Walkthrough**: [`docs/RAILS-APP-IMPLEMENTATION-GUIDE.md`](docs/RAILS-APP-IMPLEMENTATION-GUIDE.md)
* **Adding a New Release to the Lab**: [`docs/ADDING-A-NEW-RAILVERDICT-RELEASE.md`](docs/ADDING-A-NEW-RAILVERDICT-RELEASE.md)
* **CI Integration Guides**:
  * [GitHub Actions Basic Verification](docs/integration/github-actions-basic.md)
  * [GitHub Actions Changed Scope](docs/integration/github-actions-changed-scope.md)
  * [GitHub Actions PR Intelligence](docs/integration/github-actions-pr-intelligence.md)
  * [GitHub Actions Verification Receipts](docs/integration/github-actions-receipts.md)
  * [MCP Agent Integration Protocol](docs/integration/mcp-agent.md)
* **Defect Findings Register**: [`docs/findings/`](docs/findings/)
* **Phase 0 PR Triage Log**: [`docs/PR-TRIAGE-1.2.0.md`](docs/PR-TRIAGE-1.2.0.md)
* **Independent Lab Audit**: [`docs/audits/RAILVERDICT-1.2.0-LAB-AUDIT.md`](docs/audits/RAILVERDICT-1.2.0-LAB-AUDIT.md)
