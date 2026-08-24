# Adopting RailVerdict 1.2.0 in a Real Rails Application

This guide provides a comprehensive walkthrough for engineering teams adopting `rail_verdict 1.2.0` on an existing Ruby on Rails codebase.

---

## 1. Installation

Add `rail_verdict` to your `Gemfile` in the `:development, :test` group:

```ruby
# Gemfile
group :development, :test do
  gem "rail_verdict", "~> 1.2.0", require: false
end
```

Then install the gem:

```bash
bundle install
```

---

## 2. Initialize Configuration

Generate the default `.railverdict.yml` configuration:

```bash
railverdict init
```

This creates `.railverdict.yml` with schema version 1.5. Customize enabled analyzers and timeout thresholds:

```yaml
version: 1.5
mode: no_new_debt

analyzers:
  rubocop:
    enabled: true
    required: true
    timeout_seconds: 60
  rspec:
    enabled: true
    required: true
    timeout_seconds: 120
  minitest:
    enabled: false
    required: false
  simplecov:
    enabled: true
    required: false
    coverage_path: coverage/coverage.json
    freshness_window_seconds: 86400
  bundler_audit:
    enabled: true
    required: true
    timeout_seconds: 30

git:
  base: main
```

---

## 3. Environment & Tooling Diagnostics (`doctor`)

Run `railverdict doctor` to check your environment, Ruby version, Git setup, and installed analyzer processes:

```bash
railverdict doctor --format console
```

Verify that all required analyzer binaries (`rubocop`, `rspec`, `bundler-audit`, etc.) are detected and healthy.

---

## 4. Establish Initial Baseline

To adopt RailVerdict on an existing codebase with historical lint/style debt without being immediately blocked:

1. Run an initial check in advisory mode or generate a baseline:
```bash
railverdict baseline create
```
2. This creates `.railverdict-baseline.json` containing SHA-256 fingerprints of all pre-existing findings.
3. Commit `.railverdict-baseline.json` to your repository:
```bash
git add .railverdict-baseline.json .railverdict.yml
git commit -m "chore: establish initial RailVerdict baseline"
```

---

## 5. Enable No-New-Debt Policy

Ensure `.railverdict.yml` is set to `mode: no_new_debt`. Under this policy:
* Pre-existing findings listed in the baseline are classified as `existing` (non-blocking).
* Any newly introduced violation in changed files/lines is classified as `introduced` (blocking `FAIL`, exit 1).
* Resolved findings are tracked in the comparison metrics.

---

## 6. Configure CI PR Merge Gate

Add a GitHub Actions workflow `.github/workflows/railverdict.yml`:

```yaml
name: RailVerdict Verification

on:
  pull_request:
    branches: [ main ]

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.4.5'
          bundler-cache: true

      - name: Install RailVerdict
        run: gem install rail_verdict -v '~> 1.2.0'

      - name: Run Changed-Scope Verification
        run: railverdict check --changed --base origin/main --format console
```

---

## 7. Model Context Protocol (MCP) for Coding Agents

For developers or autonomous coding agents using MCP:

1. Start the MCP server:
```bash
railverdict mcp serve
```
2. The agent executes `verify` to obtain current findings and a Verification Receipt.
3. If a finding requires fixing, the agent calls `build_repair_packet` to obtain an immutable packet.
4. The agent edits code and calls `verify_repair` to verify the fix.

---

## 8. Managing Waivers

When a specific finding cannot be resolved immediately and requires a temporary waiver:

1. Create or edit `.railverdict-waivers.json`:
```json
{
  "schema_version": "1.0",
  "waivers": [
    {
      "fingerprint": "sha256:4db8e1ea2c2245bb6c349cc622a4358c157740ea1e25e496dca7a1298b81cd9e",
      "reason": "Legacy architectural constraint; scheduled refactor in Q4",
      "owner": "backend-team",
      "created_at": "2026-08-24T00:00:00Z",
      "expires_at": "2026-12-31T23:59:59Z"
    }
  ]
}
```
2. Active waivers suppress the finding (PASS). Once the UTC date passes `expires_at`, the waiver is ignored and the finding blocks the build.

---

## 9. Verification Receipts & Completion Protocol

To guarantee that an agent or developer has verified the exact commit state before merging:

```bash
# Create receipt outside repo to avoid dirtying worktree
railverdict receipt create --changed --base origin/main --format json --output /tmp/receipt.json

# Verify receipt freshness
railverdict receipt verify /tmp/receipt.json --format console
```

If any source file, configuration, index, or baseline changes after receipt creation, `receipt verify` reports `stale` (exit 2).

---

## 10. Future RailVerdict Upgrades

When upgrading to future releases of RailVerdict:
1. Update `rail_verdict` version in `Gemfile`.
2. Run `railverdict doctor` to check for new capabilities.
3. Validate configuration against new schema versions if available.
4. Run `railverdict check` to confirm baseline and waiver compatibility.
