# RVLAB-FINDING-004 — Repeated JSON verification is not deterministic

## Status

RESOLVED in RailVerdict 1.2.0 (Separation of Stable Verification Projection from Volatile Telemetry)

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

scenario ID: RVLAB-DETERMINISM-01

## Expected Behavior

Two identical offline checks in the same fixture should produce identical
canonical JSON, or explicitly exclude volatile measurements from the canonical
public contract.

## Actual Behavior

The only differing field in two consecutive checks was:

```text
analyzer_results[1].evidence_summary.duration_seconds:
0.019814509 != 0.01901983
```

The runtime timing is embedded in the public result, so canonical JSON differs
even though findings and gate are unchanged.

## Why This Is a Product Defect

Consumers cannot safely hash, compare, or cache the public verification result
as a deterministic contract when analyzer timing changes on every run.

## Exact Reproduction

```sh
scripts/lab_run --scenario RVLAB-DETERMINISM-01 --use-installed
```

The runner executes the same public `check --format json` command twice in the
same disposable repository and compares recursively canonicalized JSON.

## Public Evidence

- both commands completed with the same gate and findings
- differing field: `analyzer_results[1].evidence_summary.duration_seconds`
- example values: `0.019814509` and `0.01901983`
- Lab scenario result: FAIL

## Minimal Synthetic Reproduction

Run two consecutive public JSON checks in any valid Rails fixture with the same
baseline, configuration, and source state; compare the full JSON after sorting
object keys.

## Affected Public Contract

CLI / JSON / determinism / caching and reproducibility.

## Fail-Closed Impact

Incorrect deterministic contract and stale-cache risk for consumers that use
the full JSON document as an identity. No gate false PASS was caused by this
timing field.

## Security / Integrity Impact

No direct security impact was observed. Reproducibility and evidence integrity
are weakened.

## Workaround

Consumers must remove the runtime timing field before comparing results, while
recognizing that this is a public-contract workaround.

## Suggested Product Direction

Separate non-canonical performance telemetry from canonical verification JSON,
or document and expose a canonical projection that omits runtime timing.

## Regression Requirement

Add repeated public JSON checks and assert canonical equality for the stable
contract, with an explicit separate assertion for any non-canonical timing
metadata.
