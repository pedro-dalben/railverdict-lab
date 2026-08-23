# RVLAB-FINDING-004: Repeated JSON verification is not deterministic

- Severity: P1
- Candidate: `rail_verdict` 1.0.1, published gem SHA-256 `5a4a425ede8ea1563cca4e641e874a41b95a6f2e51eb96e759909e4f8979d3a9`
- Scenario: RVLAB-DETERMINISM-01
- Interface: public CLI JSON

## Expected

Two identical offline checks in the same fixture should produce identical
canonical JSON, or explicitly exclude volatile measurements from the contract.

## Observed

The only differing field in two consecutive checks was:

```text
analyzer_results[1].evidence_summary.duration_seconds:
0.019814509 != 0.01901983
```

The value is runtime timing embedded in the public result, so byte/canonical
determinism fails even though findings and gate are unchanged.

## Reproduction

```sh
scripts/lab_run --scenario RVLAB-DETERMINISM-01 --use-installed
```

The Lab reports FAIL. No RailVerdict source was changed.
