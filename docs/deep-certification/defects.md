# Deep-certification defects

## B-001 — `investigate` advertised and implemented but undispatched (product)

- Severity: contract violation, visible (exit 2 `unknown command`), advisory surface.
- Contract: USAGE advertises `investigate`; `command_investigate` implements it
  (config/format/preview/limit); dispatcher had no `when "investigate"` branch.
- Reproduction (candidate 1.8.2, isolated `/tmp/rv182-home`):
  `railverdict investigate --format json` → exit 2, stderr
  `railverdict: unknown command: investigate` followed by usage that lists it.
- Root cause: missing dispatch line in `RailVerdict::CLI#run`.
- Fix: `fix/1.8.3-cli-surface` commit `8e41472` (one dispatch line).
  Post-fix (isolated 1.8.3): `investigate --preview-context --format json`
  → exit 0, `{"manifests":[]}`.
- Regression: `test_cli_surface.rb#test_investigate_is_dispatched_not_unknown_command`
  (fails pre-fix with exit 2, passes post-fix; negative-controlled).
- Lab coverage: none existed (zero `investigate` argv scenarios) — DEEP CLI
  scenario added in D04/D10; obligation `O-CLI-INVESTIGATE` stays open until then.

## B-002 — `--format sarif` silently rendered console (product)

- Severity: contract violation, silent (exit 0 with prose where SARIF was requested).
- Contract: only `check` advertises `sarif`; `validate_format!` accepted it globally
  while `doctor`, `baseline create`, `findings`, `explain`, `investigate`, and
  `repair` (build) branch json/else-console.
- Reproduction (candidate 1.8.2, valid project after `init`):
  `doctor --format sarif` → exit 0, stdout `RailVerdict doctor\n\nRuby: ...`
  (console), while `doctor --format json` returns a JSON document.
- Root cause: global format allow-list instead of per-command banner contracts.
- Fix: `fix/1.8.3-cli-surface` commit `8e41472`
  (`validate_format!(format, allowed:)`; six call sites pass `console|json`).
  Post-fix: `doctor --format sarif` → exit 2, empty stdout,
  `invalid --format "sarif"; expected console, json`.
  `check --format sarif` still renders SARIF 2.1.0 (guard test).
- Regression: `test_cli_surface.rb#test_sarif_format_rejected_where_banners_promise_console_json_only`
  (fails pre-fix with console on stdout) and `#test_check_keeps_sarif_format`.
- Lab coverage: SARIF had one scenario (`RVLAB-ACCEPT-11`, check only) —
  rejection scenarios are D04 work; obligation `O-CLI-SARIF` stays partial.
