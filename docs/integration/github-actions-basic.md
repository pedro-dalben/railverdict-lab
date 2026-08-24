# GitHub Actions: Basic RailVerdict 1.2.0 Verification

This workflow provides standard, full-repository verification for RailVerdict 1.2.0 on push to `main` and pull requests.

```yaml
name: RailVerdict Verification

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.4.5'
          bundler-cache: true

      - name: Install RailVerdict
        run: gem install rail_verdict -v '~> 1.2.0'

      - name: Run RailVerdict Check
        run: railverdict check --format console
```

### Exit Codes & Behavior
* **Exit 0**: Verification passed (or advisory warnings only).
* **Exit 1**: Policy failure (new introduced debt or test failures).
* **Exit 2**: Fail-closed operational refusal (missing tools, malformed config, zero tests).
