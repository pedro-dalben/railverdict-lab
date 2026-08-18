# RailVerdict Lab

RailVerdict Lab is a controlled, real-world validation testbed for the RailVerdict gem.

## Purpose
- Validate RailVerdict product behavior on a real Rails 8.1 / Ruby 3.4 application (`OrderHub`).
- Exercise real Git history, branches, pull requests, and GitHub Actions.
- Run real analyzer processes: RuboCop, RSpec, Minitest, SimpleCov, and bundler-audit.
- Validate baseline adoption and `no_new_debt` policies against existing legacy debt.
- Test RepairPacket generation, anti-cheating verification, and the MCP stdio interface.

## Candidate Under Test
See [`lab/candidate.yml`](candidate.yml) for full metadata.
- **Gem:** `rail_verdict 0.1.0`
- **Revision:** `54ca7b555045101fed4556d68b1626ccadf34ceb`

## Directory Structure
- `app/`, `config/`, `db/`: Real Rails application
- `test/`, `spec/`: Real test suites (Minitest + RSpec)
- `lab/`: Candidate metadata and scenario manifest
- `scripts/`: Test runner, oracle, collector, and MCP client
- `docs/`: Validation plan, findings, and aggregate reports
- `artifacts/`: Execution traces and machine-readable results

## Running Validation Locally
```bash
# Run single scenario
scripts/lab_run --scenario RVLAB-01

# Run full battery
scripts/lab_run --all

# Run MCP black-box repair loop
ruby scripts/mcp_client --root .

# Collect aggregate summary
scripts/lab_collect
```
