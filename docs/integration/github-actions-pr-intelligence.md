# GitHub Actions: PR Intelligence Report

This workflow generates a structured PR Intelligence summary containing changed-scope metrics, analyzer evidence, test intelligence, coverage analysis, and risk signals.

```yaml
name: RailVerdict PR Intelligence

on:
  pull_request:
    branches: [ main ]

jobs:
  pr-intelligence:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout PR Branch
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

      - name: Generate PR Intelligence JSON
        run: railverdict pr --base origin/main --format json > pr-intelligence.json

      - name: Inspect PR Report (Console)
        run: railverdict pr --base origin/main --format console
```

### Contract Guarantees
* **Gate Authority**: The `gate` in PR Intelligence strictly mirrors the underlying `GateResult.gate`.
* **Stable Projection**: Volatile fields (e.g. wall-clock runtimes) are separated from the deterministic stable payload.
