# RailVerdict Lab 2.0

RailVerdict Lab is the permanent, synthetic external validation harness for
RailVerdict. It exercises only the user-facing gem, CLI, JSON/SARIF, MCP stdio,
configuration, package installation, and Git behavior.

The OrderHub Rails application is intentionally realistic. Broken scenarios
are part of the lab: they prove that RailVerdict rejects bad or unverifiable
changes instead of manufacturing success.

## The important distinction

The RailVerdict result and the Lab result are different:

    Scenario: required analyzer unavailable
    RailVerdict: INCOMPLETE / exit 2
    Lab: PASS, because the refusal matched the catalog contract

An expected RailVerdict FAIL or INCOMPLETE is a passing Lab scenario when both
the public semantic result and process exit code match.

## Run it

    bundle install
    scripts/lab_run --scenario RVLAB-01
    scripts/lab_run --category refusal
    scripts/lab_run --category pr_intelligence
    scripts/lab_run --all
    scripts/lab_collect

By default the runner fetches and installs the exact published gem declared in
lab/candidate.yml, verifies its SHA-256, and records the candidate identity.
For local iteration, --use-installed is available but marks package identity
as unverified. Candidate artifact mode is available with --artifact PATH.

## Contract and evidence

- lab/scenarios.yml is the versioned, machine-readable scenario contract.
- scripts/lab_run orchestrates disposable Git fixtures and public processes.
- scripts/lab_oracle checks expected completion, gate, exit, findings, and refusal semantics.
- scripts/mcp_client and scripts/mcp_protocol.rb use MCP JSON-RPC over stdio.
- artifacts/ contains raw public results, bounded diagnostics, and observations.
- docs/VALIDATION_REPORT.md is generated from the latest campaign.
- docs/findings/ records every RailVerdict defect found by the lab.

The Lab must never require RailVerdict Ruby implementation classes and must
never modify RailVerdict source.
