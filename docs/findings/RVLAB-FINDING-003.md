# RVLAB-FINDING-003: Changed-scope JSON omits deleted files

- Severity: P1
- Candidate: `rail_verdict` 1.0.1, published gem SHA-256 `5a4a425ede8ea1563cca4e641e874a41b95a6f2e51eb96e759909e4f8979d3a9`
- Scenarios: RVLAB-GIT-01
- Interface: public CLI JSON

## Expected

A changed-scope result must preserve every file reported by Git, including a
tracked deletion across multiple commits.

## Observed

The fixture's public Git diff reports:

```text
M\tREADME.md
D\tapp/models/invoice.rb
```

RailVerdict exits 0 and returns `gate: PASS`, but `git.changed_files` contains
only `README.md`. The deleted `app/models/invoice.rb` is absent from the JSON
result, so the public changed-scope evidence is incomplete.

## Reproduction

```sh
scripts/lab_run --scenario RVLAB-GIT-01 --use-installed
```

The Lab reports FAIL because the catalog requires at least two changed paths.
No RailVerdict source was changed.
