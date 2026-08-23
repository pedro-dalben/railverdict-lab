# RVLAB-FINDING-001 — RuboCop process failure aborts the public CLI

## Status

OPEN

## Severity

P0

## RailVerdict Candidate

version: 1.0.1
source SHA: unknown for published gem
gem SHA256: 5a4a425ede8ea1563cca4e641e874a41b95a6f2e51eb96e759909e4f8979d3a9

## Lab Environment

Lab SHA: 3d3a2c2e53caa37c44f9f7fa7d2caced89d67b22
Ruby: 3.4.5
Rails: 8.1.3.1
OS: Linux x86_64

## Scenario

scenario ID: RVLAB-REFUSE-01 and RVLAB-REFUSE-03

## Expected Behavior

A required analyzer that is unavailable or exits unexpectedly must produce a
public JSON result with `completion_status: incomplete`, `gate: INCOMPLETE`,
and process exit 2.

## Actual Behavior

The controlled public `bundle` process caused the CLI to terminate without a
result JSON and exit 1. The unavailable case emitted:

`ArgumentError: failure.message must be a non-empty string`

The unexpected-exit case followed the same abort path because the analyzer
failure message was empty.

## Why This Is a Product Defect

The product promises fail-closed analyzer refusal. An uncaught exception and
exit 1 prevent CI and external consumers from distinguishing an operational
INCOMPLETE result from a runner crash, and do not preserve the public gate
contract.

## Exact Reproduction

From the Lab checkout:

```bash
scripts/lab_run --scenario RVLAB-REFUSE-01 --use-installed
scripts/lab_run --scenario RVLAB-REFUSE-03 --use-installed
```

The scenario setup prepends a synthetic `bundle` executable that returns 127,
or returns `{}` with exit 3, only for the RuboCop invocation. The rest of the
analyzers remain real processes.

## Public Evidence

RVLAB-REFUSE-01:

- exit code: 1
- completion status: no JSON result
- gate: no JSON result
- diagnostic: `failure.message must be a non-empty string`

RVLAB-REFUSE-03:

- exit code: 1
- completion status: no JSON result
- gate: no JSON result
- diagnostic: the same analyzer failure contract exception

## Minimal Synthetic Reproduction

In a Rails repository with RuboCop required, put a `bundle` executable first in
`PATH` that exits 127 when its arguments contain `rubocop`, then run:

```bash
railverdict check --format json
```

Repeat with the fake executable printing `{}` and exiting 3.

## Affected Public Contract

CLI / JSON / analyzer operational status / fail-closed gate.

## Fail-Closed Impact

false INCOMPLETE represented as an unclassified process failure; CI cannot
reliably consume the required exit-2 refusal contract.

## Security / Integrity Impact

Operational evidence is not converted into a trustworthy refusal. This is not
an observed false PASS, but it weakens the integrity boundary around required
analyzers.

## Workaround

None safe. Do not weaken the analyzer requirement.

## Suggested Product Direction

Ensure every analyzer failure path supplies a non-empty public failure message
and is normalized into `AnalyzerResult` with an incomplete evidence status;
the CLI should then emit the normal INCOMPLETE JSON and exit 2.

## Regression Requirement

Add public CLI regressions for a missing required analyzer and a required
analyzer that exits nonzero with empty output. Assert JSON, completion, gate,
and exit code.
