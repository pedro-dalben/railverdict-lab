# RailVerdict Lab 2.0 Validation Plan

The permanent validation campaign is defined by lab/scenarios.yml and is
executed through public RailVerdict interfaces only. The synthetic OrderHub
application is a fixture, not a copy of any private consumer.

## Contract

Each catalog entry declares an ID, title, category, setup, command interface,
expected completion, expected gate, expected exit, cleanup strategy, tags, and
optional public capability/expectation details. scripts/lab_oracle rejects
unknown scenario structure and checks semantic state plus process exit code.

## Campaign categories

- acceptance: healthy model, request, service, authorization, migration, route, refactor, test-only, resolved-debt, and multi-file changes;
- policy_rejection: RuboCop, RSpec, Minitest, changed-scope, and multi-fault failures;
- refusal: unavailable, failing, signaled, malformed, zero-test, invalid-Git, baseline, waiver, configuration, and bounded-output cases;
- baseline_waiver: creation, existing debt, active/expired waiver, and invalid baseline lifecycle;
- git_changed_scope: add/delete/rename, Unicode/TAB/space paths, binary, empty files, and multiple commits;
- analyzers: real configured analyzers and bundler-audit compatibility evidence;
- repair_anti_cheating and mcp: public repair packets, source repair, boundary mutation, containment, tool firewall/bounds, explain/investigate previews, and same-file freshness;
- package: isolated published gem installation and CLI surface;
- format: public SARIF schema and RailVerdict driver output;
- determinism: repeated canonical public JSON;
- pr_intelligence: capability-gated public PR reports, never invented through MCP;
- multi_fault: realistic combined changes.

## Evidence boundary

The Lab may create controlled external processes to reproduce operating-system
conditions such as missing executables, malformed output, and signals. It does
not invoke RailVerdict implementation classes, edit RailVerdict source, or
replace the central behavior under test.

## Defects and reports

Unexpected product behavior is documented under docs/findings/, while the
affected scenario remains a failed Lab assertion. scripts/lab_collect builds
docs/VALIDATION_REPORT.md and artifacts/validation-summary.json from actual
campaign results; counts are never predeclared.
