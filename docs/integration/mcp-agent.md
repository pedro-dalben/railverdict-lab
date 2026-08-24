# MCP Integration: Autonomous Agent Verification Protocol

RailVerdict 1.2.0 provides an stdio-based Model Context Protocol (MCP) server adhering to the MCP 2025-11-25 specification.

## Starting the Server

```bash
railverdict mcp serve
```

## Available MCP Tools

| Tool Name | Type | Description |
|---|---|---|
| `verify` | Read-only | Runs verification and returns GateResult + embedded Verification Receipt. |
| `list_findings` | Read-only | Lists normalized findings from cache without rerunning analyzers. |
| `get_finding` | Read-only | Returns single finding by id or fingerprint. |
| `build_repair_packet` | Read-only | Generates immutable RepairPacket v1 for targeted finding. |
| `verify_repair` | Read-only | Re-verifies repair attempt and tracks boundary changes. |
| `explain` | Read-only | Returns rule explanation and bounded context manifest. |
| `investigate` | Read-only | Returns investigation manifest for top blocking findings. |
| `get_verification_receipt` | Read-only | Returns cached Verification Receipt v1. Refuses with `verification_required` if stale. |
| `get_pr_intelligence` | Read-only | Returns cached PR Intelligence v1 for changed scope. Refuses if stale. |

## Agent Loop Protocol

1. Agent modifies source files in worktree.
2. Agent calls `verify`.
3. Agent reads `verification_receipt` from response.
4. Agent performs actions while receipt remains `fresh`.
5. If repository is edited, previous cached receipt becomes `stale`, requiring a fresh `verify` call.
