# RailVerdict Lab — PR Triage for 1.2.0 Release Certification

## Executive Summary

Prior to beginning the 1.2.0 release certification and lab consolidation, all 13 open pull requests in `pedro-dalben/railverdict-lab` were inspected, evaluated for code quality, historical relevance, overlap, and risk, and assigned a definitive disposition.

### Summary Table

| PR # | Title | Branch | Base | Disposition | Action Taken / Rationale |
|---|---|---|---|---|---|
| #1 | Validation Scenario: lab/01-clean-change | `lab/01-clean-change` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-01` in `lab/scenarios.yml`. Closed with explanation. |
| #2 | Validation Scenario: lab/02-existing-debt | `lab/02-existing-debt` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-02` in `lab/scenarios.yml`. Closed with explanation. |
| #3 | Validation Scenario: lab/03-new-rubocop | `lab/03-new-rubocop` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-03` in `lab/scenarios.yml`. Merging would pollute base repo. Closed with explanation. |
| #4 | Validation Scenario: lab/04-minitest-failure | `lab/04-minitest-failure` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-04` in `lab/scenarios.yml`. Merging would break test suite. Closed with explanation. |
| #5 | Validation Scenario: lab/05-rspec-failure | `lab/05-rspec-failure` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-05` in `lab/scenarios.yml`. Merging would break spec suite. Closed with explanation. |
| #6 | Validation Scenario: lab/06-zero-tests | `lab/06-zero-tests` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-06` in `lab/scenarios.yml`. Merging would empty test suite. Closed with explanation. |
| #7 | Validation Scenario: lab/07-unavailable-analyzer | `lab/07-unavailable-analyzer` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-07` in `lab/scenarios.yml`. Merging would delete bundler-audit dependency. Closed with explanation. |
| #8 | Validation Scenario: lab/08-active-waiver | `lab/08-active-waiver` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-08` in `lab/scenarios.yml`. Closed with explanation. |
| #9 | Validation Scenario: lab/09-expired-waiver | `lab/09-expired-waiver` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-09` in `lab/scenarios.yml`. Closed with explanation. |
| #10 | Validation Scenario: lab/10-git-edge-cases | `lab/10-git-edge-cases` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-10` in `lab/scenarios.yml`. Closed with explanation. |
| #11 | Validation Scenario: lab/11-changed-scope | `lab/11-changed-scope` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-11` in `lab/scenarios.yml`. Closed with explanation. |
| #12 | Validation Scenario: lab/12-coverage-gate | `lab/12-coverage-gate` | `main` | `CLOSE_SUPERSEDED` | Superseded by dynamic scenario `RVLAB-12` in `lab/scenarios.yml`. Closed with explanation. |
| #13 | feat: build comprehensive RailVerdict Lab 2.0 | `feat/lab-2-comprehensive-validation` | `main` | `MERGE` | Establishes Lab 2.0 baseline architecture with disposable fixture execution engine, black-box oracle, MCP protocol client, and scenario catalog. |

---

## Detailed PR Evaluations

### PR #1
* **PR:** #1
* **Purpose:** Originally created as a live GitHub PR to trigger CI workflow testing a clean application change (adding `Order#calculate_tax` with passing tests).
* **Current relevance:** Obsolete as a live PR. The Lab 2.0 architecture runs scenarios dynamically in disposable cloned repositories rather than relying on persistent remote PR branches.
* **Overlap:** 100% overlap with scenario `RVLAB-01` in `lab/scenarios.yml`.
* **Unique value:** Historical prototype for PR-based validation.
* **Risks:** Merging would permanently alter `app/models/order.rb` on `main`.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Fully superseded by automated disposable fixture scenario `RVLAB-01`. Merging into `main` would pollute the baseline Rails app.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-01`.

### PR #2
* **PR:** #2
* **Purpose:** Tests existing debt protection under changed scope by modifying `app/models/customer.rb` without touching legacy debt in `app/models/order.rb`.
* **Current relevance:** Obsolete as a live PR.
* **Overlap:** 100% overlap with scenario `RVLAB-02` in `lab/scenarios.yml`.
* **Unique value:** Historical evidence of baseline debt shielding.
* **Risks:** Merging would alter baseline models on `main`.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Fully superseded by automated disposable fixture scenario `RVLAB-02`.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-02`.

### PR #3
* **PR:** #3
* **Purpose:** Introduces intentional RuboCop offenses in `app/models/order.rb` to assert FAIL gate and exit code 1.
* **Current relevance:** Obsolete as a live PR.
* **Overlap:** 100% overlap with scenario `RVLAB-03` in `lab/scenarios.yml`.
* **Unique value:** Historical evidence of RuboCop offense detection.
* **Risks:** Merging would introduce syntax/style violations into `main`, making the clean fixture dirty.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Intentionally broken code must remain in isolated test fixtures, not on `main`. Fully automated in `RVLAB-03`.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-03`.

### PR #4
* **PR:** #4
* **Purpose:** Introduces a failing Minitest assertion in `test/models/order_test.rb` to assert FAIL gate and exit code 1.
* **Current relevance:** Obsolete as a live PR.
* **Overlap:** 100% overlap with scenario `RVLAB-04` in `lab/scenarios.yml`.
* **Unique value:** Historical evidence of Minitest test failure detection.
* **Risks:** Merging would break Minitest suite on `main`.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Broken test must not be merged to `main`. Automated in `RVLAB-04`.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-04`.

### PR #5
* **PR:** #5
* **Purpose:** Introduces a failing RSpec example in `spec/models/product_spec.rb` to assert FAIL gate and exit code 1.
* **Current relevance:** Obsolete as a live PR.
* **Overlap:** 100% overlap with scenario `RVLAB-05` in `lab/scenarios.yml`.
* **Unique value:** Historical evidence of RSpec example failure detection.
* **Risks:** Merging would break RSpec suite on `main`.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Broken spec must not be merged to `main`. Automated in `RVLAB-05`.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-05`.

### PR #6
* **PR:** #6
* **Purpose:** Empties `spec/models/product_spec.rb` to assert INCOMPLETE gate and exit code 2 when 0 tests are run.
* **Current relevance:** Obsolete as a live PR.
* **Overlap:** 100% overlap with scenario `RVLAB-06` in `lab/scenarios.yml`.
* **Unique value:** Historical evidence of fail-closed zero-tests enforcement.
* **Risks:** Merging would delete specs on `main`.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Automated in `RVLAB-06`. Merging would destroy test coverage on `main`.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-06`.

### PR #7
* **PR:** #7
* **Purpose:** Removes `bundler-audit` from Gemfile to test missing analyzer refusal (INCOMPLETE gate, exit code 2).
* **Current relevance:** Obsolete as a live PR.
* **Overlap:** 100% overlap with scenario `RVLAB-07` and `RVLAB-REFUSE-01` in `lab/scenarios.yml`.
* **Unique value:** Historical evidence of missing executable refusal.
* **Risks:** Merging would remove required dependencies from `main`.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Automated in `RVLAB-07` and `RVLAB-REFUSE-01` via dynamic fixture manipulation.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-07`.

### PR #8
* **PR:** #8
* **Purpose:** Adds `.railverdict-waivers.json` with an active UTC waiver to verify suppression of a matching finding (PASS gate, exit 0).
* **Current relevance:** Obsolete as a live PR.
* **Overlap:** 100% overlap with scenario `RVLAB-08` in `lab/scenarios.yml`.
* **Unique value:** Historical evidence of active waiver suppression.
* **Risks:** Merging would add static waiver file to `main`.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Automated in `RVLAB-08`.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-08`.

### PR #9
* **PR:** #9
* **Purpose:** Adds `.railverdict-waivers.json` with an expired UTC waiver to verify that expired waivers do not suppress findings (FAIL gate, exit 1).
* **Current relevance:** Obsolete as a live PR.
* **Overlap:** 100% overlap with scenario `RVLAB-09` in `lab/scenarios.yml`.
* **Unique value:** Historical evidence of expired waiver enforcement.
* **Risks:** Merging would add expired waiver file to `main`.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Automated in `RVLAB-09`.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-09`.

### PR #10
* **PR:** #10
* **Purpose:** Tests Git path handling including file renames (`app/models/billing_invoice.rb`), binary assets (`logo.png`), and special names (`special_item.rb`).
* **Current relevance:** Obsolete as a live PR.
* **Overlap:** 100% overlap with scenario `RVLAB-10` and `RVLAB-GIT-*` in `lab/scenarios.yml`.
* **Unique value:** Historical evidence of git path and rename normalization.
* **Risks:** Merging would alter domain models on `main`.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Automated in `RVLAB-10` and `RVLAB-GIT-01..04`.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-10`.

### PR #11
* **PR:** #11
* **Purpose:** Tests changed-scope isolation between new PR regressions and baseline debt.
* **Current relevance:** Obsolete as a live PR.
* **Overlap:** 100% overlap with scenario `RVLAB-11` in `lab/scenarios.yml`.
* **Unique value:** Historical evidence of changed-scope diff evaluation.
* **Risks:** Merging would pollute `main`.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Automated in `RVLAB-11`.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-11`.

### PR #12
* **PR:** #12
* **Purpose:** Tests SimpleCov changed-line coverage gate enforcement.
* **Current relevance:** Obsolete as a live PR.
* **Overlap:** 100% overlap with scenario `RVLAB-12` in `lab/scenarios.yml`.
* **Unique value:** Historical evidence of coverage gate enforcement.
* **Risks:** Merging would pollute `main`.
* **Decision:** `CLOSE_SUPERSEDED`
* **Reason:** Automated in `RVLAB-12` and `RVLAB-SIMPLECOV-*`.
* **Required follow-up:** Close with explanatory comment referencing `RVLAB-12`.

---

### Special Assessment: PR #13

* **PR:** #13
* **Purpose:** Re-architects `railverdict-lab` into a fully automated, black-box validation harness with disposable Git/Rails fixtures, independent oracle, MCP stdio protocol client, 58 catalogued scenarios, and defect finding documentation.
* **Current relevance:** Crucial foundational architecture for all subsequent validation.
* **Overlap:** Supersedes all previous branch-based scenario PRs (#1 - #12).
* **Unique value:** Provides the entire automated execution harness (`scripts/lab_run`, `scripts/lab_oracle`, `scripts/lab_collect`, `scripts/lab_support.rb`, `scripts/mcp_client`, `scripts/mcp_protocol.rb`, `lab/scenarios.yml`, `test/unit/lab_infrastructure_test.rb`).
* **Risks:** Pinned to 1.0.1; needs upgrade to 1.2.0 contract matrix, verification receipts, state identity, and SimpleCov native JSON.
* **Decision:** `MERGE` (Selected Option A: Become the new Lab baseline before 1.2.0 work).
* **Reason:** PR #13 contains sound, black-box architectural design. Code and tests prove it executes scenarios independently without touching RailVerdict internals. Merging it creates a clean, authoritative Lab 2.0 baseline on `main`.
* **Required follow-up:** Merge PR #13 into `main`, then integrate the 1.2.0 protocol additions (from `feat/lab-2-agent-protocol`) and expand with full 1.2.0 contract matrix, SimpleCov native JSON, large-output safety, receipts, freshness, mutation guard, determinism, and anti-cheating scenarios.

---

## Conclusion & Action Plan

1. Merge PR #13 into `main` to establish the Lab 2.0 architecture as canonical.
2. Close PRs #1 through #12 with explicit references to the automated scenario IDs in `lab/scenarios.yml`.
3. Commit this triage document to git.
4. Proceed to Phase 1 (Product Contract Matrix for 1.2.0).
