# RailVerdict Lab — Real-World Validation Repository

This repository is a separate, synthetic validation laboratory for the **RailVerdict** verification framework.

> ⚠️ **IMPORTANT**: This repository contains intentionally broken branches and synthetic offenses designed to exercise merge-gate validation. **Do not merge scenario pull requests.**

## Overview
- **Domain:** OrderHub (Customers, Orders, Invoices, Products)
- **Framework:** Ruby on Rails 8.1.3.1 on Ruby 3.4.5
- **Verified Candidate:** RailVerdict 0.1.0 (Git SHA: `54ca7b555045101fed4556d68b1626ccadf34ceb`)
- **Analyzers:** RuboCop, RSpec, Minitest, SimpleCov, bundler-audit

## Quick Start
```bash
# Install dependencies
bundle install

# Run verification check
railverdict check

# Run verification in changed scope against main
railverdict check --changed --base main

# Run Lab Oracle on a scenario
scripts/lab_run --scenario RVLAB-01

# Run complete local scenario battery
scripts/lab_run --all

# Run MCP stdio black-box repair loop
ruby scripts/mcp_client --root .
```

## Documentation
- [`docs/VALIDATION_PLAN.md`](docs/VALIDATION_PLAN.md): Full validation matrix and test plan
- [`docs/VALIDATION_REPORT.md`](docs/VALIDATION_REPORT.md): Empirical report with metrics
- [`docs/findings/`](docs/findings/): Documented product findings and defect reproductions
- [`lab/scenarios.yml`](lab/scenarios.yml): Machine-readable scenario catalog
