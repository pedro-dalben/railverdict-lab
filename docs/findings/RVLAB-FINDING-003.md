# RVLAB-FINDING-003 — Changed-scope JSON omits deleted files

## Status

RESOLVED in RailVerdict 1.2.0 (Discovered in 1.0.1; Verified Fixed in 1.2.0)

## Severity

P1

## RailVerdict Candidate

version: 1.0.1  
source SHA: unknown for published gem  
gem SHA256: 5a4a425ede8ea1563cca4e641e874a41b95a6f2e51eb96e759909e4f8979d3a9

## Lab Environment

Lab SHA: eaff5d8a67524f354bc6008f9c271f7f7c60994d  
Ruby: 3.4.5  
Rails: 8.1.3.1  
Bundler: 2.7.1  
OS: Linux x86_64

## Scenario

scenario ID: RVLAB-GIT-01

## Expected Behavior

A changed-scope result must preserve every file reported by Git, including a
tracked deletion across multiple commits.

## Actual Behavior

The fixture's public Git diff reports:

```text
M\tREADME.md
D\tapp/models/invoice.rb
```

RailVerdict exits 0 and returns `gate: PASS`, but `git.changed_files` contains
only `README.md`. The deleted file is absent from the public JSON result.

## Why This Is a Product Defect

The public changed-scope evidence is incomplete. Consumers cannot reliably
reason about deletion-only or mixed multi-commit changes from the returned
changed-file set.

## Exact Reproduction

```sh
scripts/lab_run --scenario RVLAB-GIT-01 --use-installed
```

The runner creates two real commits, deletes `app/models/invoice.rb`, modifies
`README.md`, and invokes `check --changed --base main --format json`.

## Public Evidence

- exit code: 0
- completion status: complete
- gate: PASS
- Git diff paths: `README.md`, `app/models/invoice.rb` (deleted)
- JSON `git.changed_files`: `README.md` only

## Minimal Synthetic Reproduction

In a Rails repository with a valid baseline, make a tracked deletion in one
commit and modify a second tracked file in another commit. Run changed-scope
JSON verification against the original base.

## Affected Public Contract

CLI / JSON / Git changed scope / metrics.

## Fail-Closed Impact

Incorrect metric and incomplete scope evidence. This observed case did not
produce a false PASS on a policy finding, but it can hide affected paths from
downstream consumers.

## Security / Integrity Impact

Integrity impact is limited to incomplete change provenance in the public
result; no command execution or secret exposure was observed.

## Workaround

Consumers that require complete path provenance must independently compare
`git diff --name-status` until the product preserves deletions.

## Suggested Product Direction

Build `git.changed_files` from the complete NUL-delimited Git diff stream and
retain deletion status and path fields through JSON serialization.

## Regression Requirement

Add a public CLI regression with a deleted tracked file across multiple commits
and assert that the deletion appears in `git.changed_files` with its status.
