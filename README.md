# RailVerdict Lab 2.0

RailVerdict Lab is a permanent external black-box validation harness for the
published `rail_verdict` gem. It exercises the public package, CLI, JSON,
SARIF, MCP stdio, Git, analyzer, baseline, waiver, repair, and PR-facing
contracts without loading RailVerdict implementation classes or changing
RailVerdict source code.

The synthetic OrderHub Rails application is deliberately realistic. Broken
fixtures are part of the test: they prove that the candidate rejects bad or
unverifiable changes instead of manufacturing success.

> This repository contains intentionally broken synthetic branches and PR
> scenarios. They are validation examples, not product changes to merge.

## What this repository is

This repository is the validation lab, not the RailVerdict product.

The lab installs a frozen candidate from [`lab/candidate.yml`](lab/candidate.yml),
creates disposable Git/Rails fixtures, invokes only public processes, captures
their output, and evaluates it with an independent oracle.

The current candidate is `rail_verdict` 1.0.1 with SHA-256:

```text
5a4a425ede8ea1563cca4e641e874a41b95a6f2e51eb96e759909e4f8979d3a9
```

## How to read a result

There are two results to distinguish:

```text
RailVerdict result: INCOMPLETE / exit 2
Lab result:        PASS
```

The Lab result is about contract matching. An expected RailVerdict `FAIL` or
`INCOMPLETE` is a Lab `PASS` when the public semantic result, evidence, and
process exit code match the catalog.

| Lab status | Meaning |
|---|---|
| `PASS` | The candidate matched the scenario's public contract. |
| `FAIL` | The candidate produced an unexpected public result; inspect `docs/findings/`. |
| `BLOCKED` | The harness could not execute or inspect the scenario; this is infrastructure evidence, not a product verdict. |
| `SKIPPED` | The candidate did not publicly declare the capability required by the scenario. |

The runner intentionally preserves `FAIL` and `BLOCKED` as non-zero process
statuses. It never turns a product defect into a green check.

## Run locally

Install the lab dependencies and run one scenario, a category, or the full
campaign:

```bash
bundle install

# One public scenario
scripts/lab_run --scenario RVLAB-01

# One validation area
scripts/lab_run --category refusal
scripts/lab_run --category mcp
scripts/lab_run --category pr_intelligence

# Complete campaign and report
scripts/lab_run --all
scripts/lab_collect
```

By default, `scripts/lab_run` downloads/installs the exact published gem from
`lab/candidate.yml`, verifies its SHA-256, and records the candidate identity.

For local development only:

```bash
scripts/lab_run --scenario RVLAB-01 --use-installed
scripts/lab_run --scenario RVLAB-01 --artifact /path/to/rail_verdict.gem
```

`--use-installed` is explicitly marked as unverified package identity in the
artifacts. It must not replace the published-package campaign in a release or
PR report.

## PR validation

The GitHub Actions workflow runs one disposable job per category on every pull
request to `main`:

| Category | What it covers |
|---|---|
| `acceptance` | Healthy model, request, service, authorization, migration, route, refactor, test-only, and multi-file changes. |
| `policy_rejection` | Real RuboCop, RSpec, Minitest, changed-scope, and multi-fault failures. |
| `refusal` | Missing/failing/signaled/malformed analyzers, zero tests, invalid Git/base/baseline/waiver/config, and bounded evidence. |
| `baseline_waiver` | Baseline creation, existing debt, active/expired waivers, and invalid baseline data. |
| `git_changed_scope` | Adds, deletes, renames, Unicode/TAB/space paths, binary/empty files, and multi-commit scope. |
| `analyzers` | Real configured analyzers and public `bundler-audit` evidence. |
| `repair_anti_cheating` | MCP repair packets, source repair, policy weakening, waiver injection, and baseline mutation. |
| `mcp` | Public MCP tools, containment, argument bounds, explain/investigate previews, and evidence freshness. |
| `package` | Isolated published gem installation and CLI surface. |
| `determinism` | Repeated canonical public JSON. |
| `multi_fault` | A realistic change with healthy tests and a real quality regression. |
| `pr_intelligence` | Public PR reports only when the candidate exposes a public `pr` command. |

### PR Intelligence is capability-gated

`RVLAB-PR-01` through `RVLAB-PR-04` validate the candidate's public PR
projection when available. The lab checks the frozen capability declaration and
the public CLI help before running them.

The current 1.0.1 candidate declares:

```yaml
pr_intelligence: false
```

Therefore those four scenarios are `SKIPPED`. The Lab does not invent PR
Intelligence through MCP or private Ruby APIs. A future candidate exposing a
public `pr` command will automatically exercise the scenarios.

### Why a Lab PR can be red

The Lab is an external validator, so a red category means the published
candidate violated a contract. That is useful evidence, not necessarily a
failure of the harness.

For example, the Lab expects an unavailable required analyzer to return
`INCOMPLETE` with exit code `2`. If the candidate crashes with exit code `1`,
the refusal job is correctly red and a finding is recorded.

The final PR #13 campaign demonstrates this distinction:

| Result | Count |
|---|---:|
| Scenarios | 58 |
| Contract matches | 48 |
| Product mismatches | 5 |
| Capability skips | 5 |
| Harness blocks | 0 |

The PR is `UNSTABLE` because the known product mismatches are intentionally
propagated by CI. The current PR is a validation baseline, not a RailVerdict
product fix.

## Findings from PR #13

| Finding | Severity | Scenarios | Observed behavior |
|---|---|---|---|
| [001](docs/findings/RVLAB-FINDING-001.md) | P0 | `RVLAB-REFUSE-01`, `RVLAB-REFUSE-03` | Required analyzer failure aborts without JSON and exits `1` instead of returning `INCOMPLETE/2`. |
| [002](docs/findings/RVLAB-FINDING-002.md) | P0 | `RVLAB-16` | MCP waiver injection leaves the target present but returns repair `PASS` and exit `0`. |
| [003](docs/findings/RVLAB-FINDING-003.md) | P1 | `RVLAB-GIT-01` | Public `git.changed_files` omits a tracked deleted file. |
| [004](docs/findings/RVLAB-FINDING-004.md) | P1 | `RVLAB-DETERMINISM-01` | Repeated JSON differs in analyzer timing telemetry. |

The generated evidence is in
[`docs/VALIDATION_REPORT.md`](docs/VALIDATION_REPORT.md). Raw public results,
oracle diagnostics, and candidate identity are written under `artifacts/`.

## Evidence boundary

The lab may create controlled external processes to reproduce operating-system
conditions such as missing executables, malformed output, signals, and bounded
output. It does not:

- require `RailVerdict::` implementation classes;
- require `require "rail_verdict"` from the lab scripts;
- edit RailVerdict source;
- replace the product's public result with an internal assumption;
- treat a queued, skipped, or unavailable check as proof of success.

The campaign validates CLI/MCP/package behavior. It does not prove hosted
client, player, browser, or production deployment behavior.

## Repository layout

```text
lab/candidate.yml          frozen candidate package and capabilities
lab/scenarios.yml          executable scenario catalog
scripts/lab_run            public black-box runner
scripts/lab_oracle         independent contract oracle
scripts/lab_collect        report generator
scripts/mcp_client         standalone MCP black-box client
scripts/lab_support.rb     disposable fixture/process helpers
test/unit/                 lab infrastructure tests
docs/VALIDATION_PLAN.md    campaign design and evidence boundary
docs/VALIDATION_REPORT.md  latest empirical campaign report
docs/findings/             product findings with reproductions
artifacts/                 ignored raw campaign output
```

## Adding a scenario

Add a versioned entry to `lab/scenarios.yml` with setup, public command,
expected semantic completion, expected gate, expected exit, cleanup, and tags.
Keep the scenario independent of RailVerdict internals. Then run the smallest
focused category, the oracle self-test, and finally the full campaign before
refreshing `docs/VALIDATION_REPORT.md`.

The lab's contract is intentionally explicit: unexpected product behavior is
documented as a finding while the affected scenario remains a failed assertion.
