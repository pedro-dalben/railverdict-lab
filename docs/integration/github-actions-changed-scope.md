# GitHub Actions: Changed-Scope Verification (PR Merge Gate)

This workflow evaluates only the files and lines changed in a Pull Request against the merge-base of the base branch (`main`).

```yaml
name: RailVerdict Changed Scope

on:
  pull_request:
    branches: [ main ]

jobs:
  changed-scope-check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout PR Branch
        uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Full history required for merge-base calculation

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.4.5'
          bundler-cache: true

      - name: Install RailVerdict
        run: gem install rail_verdict -v '~> 1.2.0'

      - name: Run Changed-Scope Check
        run: railverdict check --changed --base origin/main --format console
```

### Key Highlights
* **Historical Debt Shielding**: Pre-existing debt captured in `.railverdict-baseline.json` is not blocking.
* **Deleted Files Preservation**: Tracked file deletions across multiple commits are preserved in changed-scope evaluation.
* **Fail-Closed on Missing Base**: If the base branch cannot be resolved, RailVerdict fails closed with exit code 2.
