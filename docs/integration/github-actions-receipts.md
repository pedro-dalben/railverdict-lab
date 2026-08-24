# GitHub Actions: Verification Receipts & Agent Completion Protocol

This workflow integrates Verification Receipts v1 to certify agent work and ensure no unverified state mutation occurred prior to merge.

```yaml
name: RailVerdict Agent Receipt Verification

on:
  pull_request:
    branches: [ main ]

jobs:
  receipt-gate:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.4.5'
          bundler-cache: true

      - name: Install RailVerdict
        run: gem install rail_verdict -v '~> 1.2.0'

      - name: Issue Verification Receipt
        run: |
          # Write receipt outside repository to prevent self-invalidating worktree mutation
          railverdict receipt create --changed --base origin/main --format json --output /tmp/receipt.json

      - name: Verify Receipt Freshness
        run: |
          railverdict receipt verify /tmp/receipt.json --format console
```

### Exit Semantics
| State | Exit Code | Meaning |
|---|---|---|
| Fresh + PASS/WARN | `0` | State is verified and policy passes. |
| Fresh + FAIL | `1` | State is verified and policy fails. |
| Stale / Invalid / Unavailable | `2` | State modified after verification, receipt tampered, or state indeterminate. |
