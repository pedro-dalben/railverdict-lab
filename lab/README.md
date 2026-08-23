# Lab Contract

The catalog in scenarios.yml is the executable contract for RailVerdict Lab
2.0. Every scenario declares its setup, public interface, expected semantic
completion, expected gate, expected process exit, cleanup, and tags.

Run one scenario, a category, or the complete campaign:

    scripts/lab_run --scenario RVLAB-REFUSE-01
    scripts/lab_run --category refusal
    scripts/lab_run --all
    scripts/lab_collect

The runner uses disposable real Git repositories, real Rails files, real
analyzer processes, a published or explicit gem artifact, and MCP stdio. The
oracle parses public output only.

Expected product failure is not Lab failure. For example, RailVerdict
INCOMPLETE/2 for a missing required analyzer is Lab PASS when that is the
catalog expectation. A product PASS where the catalog expects INCOMPLETE is a
Lab failure and is recorded as a possible false-pass defect.
