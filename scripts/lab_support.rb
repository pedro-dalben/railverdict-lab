#!/usr/bin/env ruby
# frozen_string_literal: true

require "digest"
require "fileutils"
require "json"
require "open3"
require "rbconfig"
require "shellwords"
require "tmpdir"

module LabSupport
  module_function

  def run(argv, cwd:, env: {})
    Open3.capture3(env, *argv, chdir: cwd)
  end

  def git(work_dir, *args)
    run(["git", "-C", work_dir, *args], cwd: work_dir)
  end

  def json(stdout)
    JSON.parse(stdout)
  rescue JSON::ParserError
    {}
  end
  def json_strict(stdout)
    JSON.parse(stdout)
  end

  def canonical(value)
    case value
    when Hash
      value.keys.sort.each_with_object({}) { |key, result| result[key] = canonical(value[key]) }
    when Array
      value.map { |item| canonical(item) }
    else
      value
    end
  end

  def stable_result_projection(result_json)
    res = canonical(result_json)
    if res["analyzer_results"].is_a?(Array)
      res["analyzer_results"].each do |ar|
        if ar["evidence_summary"].is_a?(Hash)
          ar["evidence_summary"].delete("duration_seconds")
          ar["evidence_summary"].delete("_coverage_document")
        end
      end
    end
    res
  end

  def fixture_env(env, cwd)
    env = env.dup
    # Do not set BUNDLE_GEMFILE for railverdict candidate runs; it causes Gem.use_gemdeps wrapper to fail
    # when rail_verdict is not in the fixture's Gemfile. Bundler will still find Gemfile via cwd.
    # Only set BUNDLE_PATH config if needed without BUNDLE_GEMFILE.
    gemfile = File.join(cwd, "Gemfile")
    if File.file?(gemfile) && env["BUNDLE_PATH"] && !env["BUNDLE_PATH"].empty?
      bundle_config = File.join(cwd, ".bundle", "config")
      FileUtils.mkdir_p(File.dirname(bundle_config))
      File.write(bundle_config, "---\nBUNDLE_PATH: #{env["BUNDLE_PATH"].inspect}\n")
    end
    env
  end

  def product_run(candidate, args, cwd:, extra_env: {}, timeout_seconds: nil)
    env = fixture_env(candidate.env.merge(extra_env), cwd)
    argv = [candidate.command, *args]
    # timeout(1): TERM first for a clean shutdown, KILL after a 5s grace period.
    # A timeout surfaces as exit 124; a bare -s KILL would report 137 instead.
    argv = ["timeout", "-k", "5", timeout_seconds.to_i.to_s, *argv] if timeout_seconds
    run(argv, cwd: cwd, env: env)
  end

  def clone_fixture(repo_root, work_dir, branch: nil)
    FileUtils.rm_rf(work_dir)
    FileUtils.mkdir_p(File.dirname(work_dir))
    _stdout, stderr, status = run(["git", "clone", "--quiet", "file://#{repo_root}", work_dir], cwd: repo_root)
    raise "fixture clone failed: #{stderr}" unless status.success?

    git(work_dir, "config", "user.email", "lab@example.invalid")
    git(work_dir, "config", "user.name", "RailVerdict Lab")
    _stdout, stderr, status = current_branch = git(work_dir, "rev-parse", "--abbrev-ref", "HEAD").first.to_s.strip
    if current_branch != "main"
      _stdout, stderr, status = git(work_dir, "checkout", "-B", "main", "HEAD")
      raise "fixture base branch failed: #{stderr}" unless status.success?
    end
    return unless branch

    _stdout, stderr, status = git(work_dir, "checkout", "-b", branch)
    raise "fixture branch failed: #{stderr}" unless status.success?
  end
  def fixture_identity(work_dir)
    head_out, head_err, head_status = git(work_dir, "rev-parse", "HEAD")
    branch_out, _branch_err, branch_status = git(work_dir, "rev-parse", "--abbrev-ref", "HEAD")
    status_out, _status_err, _status_status = git(work_dir, "status", "--short")
    {
      "base_commit" => head_status.success? ? head_out.strip : "unavailable:#{head_err.strip[0, 200]}",
      "branch" => branch_status.success? ? branch_out.strip : "unavailable",
      "status" => status_out.strip
    }
  rescue StandardError => error
    { "error" => "#{error.class}: #{error.message}" }
  end
  def stage(work_dir, paths)
    _stdout, stderr, status = git(work_dir, "add", "--", *Array(paths))
    raise "fixture stage failed: #{stderr}" unless status.success?
  end
  def acquire_scenario_lock(root, id)
    lock_dir = File.join(root, "artifacts", "#{id}.lock")
    FileUtils.mkdir_p(File.dirname(lock_dir))
    begin
      Dir.mkdir(lock_dir)
    rescue Errno::EEXIST
      holder = begin
        File.read(File.join(lock_dir, "pid")).strip
      rescue StandardError
        "unknown"
      end
      alive = holder =~ /\A\d+\z/ && begin
        Process.kill(0, holder.to_i)
        true
      rescue StandardError
        false
      end
      return { "locked" => false, "holder" => holder } if alive
      FileUtils.rm_rf(lock_dir)
      Dir.mkdir(lock_dir)
    end
    File.write(File.join(lock_dir, "pid"), Process.pid.to_s)
    { "locked" => true, "lock_dir" => lock_dir }
  end

  def release_scenario_lock(lock)
    return unless lock.is_a?(Hash) && lock["locked"]
    dir = lock["lock_dir"]
    pid_file = File.join(dir, "pid")
    current = begin
      File.read(pid_file).strip
    rescue StandardError
      nil
    end
    FileUtils.rm_rf(dir) if current == Process.pid.to_s
  end

  def fresh_fixture(work_dir)
    FileUtils.rm_rf(work_dir)
    FileUtils.mkdir_p(work_dir)
    _stdout, stderr, status = run(["git", "init", "--quiet", "-b", "main", work_dir], cwd: work_dir)
    raise "fresh fixture init failed: #{stderr}" unless status.success?

    git(work_dir, "config", "user.email", "lab@example.invalid")
    git(work_dir, "config", "user.name", "RailVerdict Lab")
  end

  def commit(work_dir, message = "scenario change")
    _stdout, stderr, status = git(work_dir, "add", "--all")
    raise "fixture git add failed: #{stderr}" unless status.success?
    _stdout, stderr, status = git(work_dir, "commit", "--quiet", "--allow-empty", "-m", message)
    raise "fixture git commit failed: #{stderr}" unless status.success?
  end

  def write_file(work_dir, path, content, binary: false)
    absolute = File.join(work_dir, path)
    FileUtils.mkdir_p(File.dirname(absolute))
    binary ? File.binwrite(absolute, content) : File.write(absolute, content)
  end

  def append(work_dir, path, content)
    absolute = File.join(work_dir, path)
    FileUtils.mkdir_p(File.dirname(absolute))
    File.open(absolute, "ab") { |file| file.write(content) }
  end

  def apply_operations(work_dir, operations, candidate:, env: {})
    operations.each do |operation|
      operation = { "name" => operation } if operation.is_a?(String)
      name = operation.fetch("name")

      case name
      when "write"
        write_file(work_dir, operation.fetch("path"), operation.fetch("content"))
      when "append"
        path = File.join(work_dir, operation.fetch("path"))
        write_file(work_dir, operation.fetch("path"), "") unless File.file?(path)
        File.open(path, "ab") { |file| file.write(operation.fetch("content")) }
      when "replace"
        path = File.join(work_dir, operation.fetch("path"))
        original = File.read(path)
        replacement = operation.fetch("to")
        replacement = replacement.sub("\n  def", "\n\n  def") if replacement.start_with?("\n  def")
        content = original.sub(operation.fetch("from"), replacement)
        raise "replace target not found: #{operation.fetch('path')}" if content == original
        File.write(path, content)
      when "delete"
        FileUtils.rm_f(File.join(work_dir, operation.fetch("path")))
      when "rename"
        source = File.join(work_dir, operation.fetch("from"))
        target = File.join(work_dir, operation.fetch("to"))
        FileUtils.mkdir_p(File.dirname(target))
        FileUtils.mv(source, target)
      when "binary"
        write_file(work_dir, operation.fetch("path"), [operation.fetch("hex")].pack("H*"), binary: true)
      when "mkdir"
        FileUtils.mkdir_p(File.join(work_dir, operation.fetch("path")))
      when "install_large_rspec"
        install_large_rspec(work_dir, operation.fetch("count", 1500))
      when "write_native_simplecov"
        coverage_data = {
          "meta" => { "simplecov_version" => "0.22.0" },
          "timestamp" => Time.now.to_i,
          "coverage" => {
            File.join(work_dir, operation.fetch("target_file", "app/models/order.rb")) => {
              "lines" => operation.fetch("lines", [1, 1, nil, "ignored", 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
            }
          }
        }
        write_file(work_dir, "coverage/coverage.json", JSON.pretty_generate(coverage_data))
      when "remove", "remove_file"
        FileUtils.rm_f(File.join(work_dir, operation.fetch("path")))
      when "config_replace"
        path = File.join(work_dir, ".railverdict.yml")
        original = File.read(path)
        updated = original.sub(operation.fetch("from"), operation.fetch("to"))
        raise "config_replace target not found: #{operation.fetch('from').inspect}" if updated == original
        File.write(path, updated)
      when "remove_dependency"
        gem_name = operation.fetch("gem")
        gemfile = File.join(work_dir, "Gemfile")
        File.write(gemfile, File.readlines(gemfile).reject { |line| line.include?("gem \"#{gem_name}\"") }.join)
        _stdout, stderr, status = run(["bundle", "lock", "--local"], cwd: work_dir)
        raise "bundle lock --local failed: #{stderr}" unless status.success?
      when "fake_bundle"
        install_fake_bundle(work_dir, operation)
        env["PATH"] = "#{File.join(work_dir, "tmp", "fake-bin")}:#{ENV.fetch("PATH", "")}".freeze
      when "commit"
        commit(work_dir, operation.fetch("message", "scenario change"))
      when "stage"
        stage(work_dir, operation.fetch("paths", operation.fetch("path", [])))
      when "baseline_create"
        _stdout, stderr, status = product_run(candidate, ["baseline", "create"], cwd: work_dir, extra_env: env)
        raise "baseline create failed: #{stderr}" unless status.success?
      when "waiver_from_current"
        commit(work_dir, "scenario change before waiver")
        stdout, stderr, status = product_run(candidate, ["check", "--changed", "--base", "main", "--format", "json"], cwd: work_dir, extra_env: env)
        raise "waiver probe failed: #{stderr}" unless status.exitstatus == 0 || status.exitstatus == 1
        finding = json(stdout).fetch("findings", []).find { |item| item["state"] == "introduced" }
        raise "waiver probe found no introduced finding" unless finding
        waiver = {
          "schema_version" => "1.0",
          "waivers" => [{
            "fingerprint" => finding.fetch("fingerprint"),
            "reason" => operation.fetch("reason", "synthetic lab waiver"),
            "owner" => "railverdict-lab",
            "created_at" => "2026-01-01T00:00:00Z",
            "expires_at" => operation.fetch("expires_at", "2099-01-01T00:00:00Z")
          }]
        }
        write_file(work_dir, ".railverdict-waivers.json", JSON.pretty_generate(waiver))
      when "prepare_fake_project"
        write_file(work_dir, ".railverdict.yml", operation.fetch("config"))
        write_file(work_dir, ".rubocop.yml", operation.fetch("rubocop_config", "AllCops:\n  TargetRubyVersion: 3.4\n"))
        write_file(work_dir, operation.fetch("path", "app.rb"), operation.fetch("content", "x = 1\n"))
      when "write_json"
        write_file(work_dir, operation.fetch("path"), JSON.pretty_generate(operation.fetch("content")))
      when "write_raw"
        write_file(work_dir, operation.fetch("path"), operation.fetch("content"))
      when "symlink"
        target = File.join(work_dir, operation.fetch("target"))
        link = File.join(work_dir, operation.fetch("path"))
        FileUtils.mkdir_p(File.dirname(link))
        FileUtils.ln_sf(target, link)
      when "ensure_coverage_dir"
        FileUtils.mkdir_p(File.join(work_dir, "coverage"))
      else
        raise "unknown scenario operation: #{name}"
      end
    end
    env
  end

  def install_fake_bundle(work_dir, operation)
    bin_dir = File.join(work_dir, "tmp", "fake-bin")
    FileUtils.mkdir_p(bin_dir)
    real_bundle = Gem.bin_path("bundler", "bundle")
    behavior = operation.fetch("behavior")
    analyzer = operation.fetch("analyzer", "rubocop")
    # Support multiple analyzers via comma-separated list or "all"
    grep_pattern = if analyzer == "all"
      ""
    else
      analyzer.split(",").map(&:strip).join("|")
    end
    condition = if grep_pattern.empty?
      "true"
    elsif analyzer.include?(",")
      "printf '%s\n' \"$*\" | grep -Eq -- '#{grep_pattern}'"
    else
      "printf '%s\n' \"$*\" | grep -q -- '#{analyzer}'"
    end
    script = <<~SH
      #!/bin/sh
      if #{condition} ; then
        #{fake_behavior(behavior)}
      fi
      exec #{Shellwords.escape(real_bundle)} "$@"
    SH
    write_file(work_dir, "tmp/fake-bin/bundle", script)
    FileUtils.chmod("u+x", File.join(bin_dir, "bundle"))
  end

  def fake_behavior(behavior)
    case behavior
    when "missing"
      "exit 127"
    when "brakeman_clean"
      "case \"\$*\" in *--version*) echo 'brakeman 8.0.6'; exit 0;; esac\nOUT=\"\"; PREV=\"\"; for ARG in \"$@\"; do if [ \"$PREV\" = \"-o\" ] || [ \"$PREV\" = \"--output\" ]; then OUT=\"$ARG\"; fi; PREV=\"$ARG\"; done\nif [ -n \"$OUT\" ]; then mkdir -p \"$(dirname \"$OUT\")\"; printf '%s' '{\"scan_info\":{\"app_path\":\"/app\",\"rails_version\":\"8.0.1\",\"brakeman_version\":\"8.0.6\",\"ruby_version\":\"3.4.0\",\"security_warnings\":0,\"duration\":0.05,\"checks_performed\":[\"SQL\",\"SendFile\"]},\"warnings\":[],\"errors\":[],\"obsolete\":[]}' > \"$OUT\"; fi\nexit 0"
    when "brakeman_warnings"
      "case \"\$*\" in *--version*) echo 'brakeman 8.0.6'; exit 0;; esac\nOUT=\"\"; PREV=\"\"; for ARG in \"$@\"; do if [ \"$PREV\" = \"-o\" ] || [ \"$PREV\" = \"--output\" ]; then OUT=\"$ARG\"; fi; PREV=\"$ARG\"; done\nif [ -n \"$OUT\" ]; then mkdir -p \"$(dirname \"$OUT\")\"; printf '%s' '{\"scan_info\":{\"app_path\":\"/app\",\"rails_version\":\"8.0.1\",\"brakeman_version\":\"8.0.6\",\"ruby_version\":\"3.4.0\",\"security_warnings\":1,\"duration\":0.05,\"checks_performed\":[\"SQL\"]},\"warnings\":[{\"warning_type\":\"SQL Injection\",\"warning_code\":0,\"fingerprint\":\"1111111111111111111111111111111111111111111111111111111111111111\",\"check_name\":\"SQL\",\"message\":\"Possible SQL injection\",\"file\":\"app/models/order.rb\",\"line\":42,\"confidence\":\"High\"}],\"errors\":[],\"obsolete\":[]}' > \"$OUT\"; fi\nexit 3"
    when "brakeman_exit2"
      "case \"\$*\" in *--version*) echo 'brakeman 8.0.6'; exit 0;; esac\nprintf '%s\\n' 'Fatal Brakeman crash' >&2; exit 2"
    when "unexpected_exit"
      "case \"\$*\" in *--version*) echo '1.88.0'; exit 0;; esac\nprintf '%s' '{}'; exit 3"
    when "malformed_json"
      "case \"\$*\" in *--version*) echo '1.88.0'; exit 0;; esac\nprintf '%s' '{not-json'; exit 0"
    when "missing_json"
      "case \"\$*\" in *--version*) echo '1.88.0'; exit 0;; esac\nprintf '%s' '{}'; exit 0"
    when "timeout"
      "case \"\$*\" in *--version*) echo '1.88.0'; exit 0;; esac\nsleep 3; printf '%s' '{}'; exit 0"
    when "wait_gate"
      "case \"$*\" in *--version*) echo '1.88.0'; exit 0;; esac\nmkdir -p tmp\nprintf '1' > tmp/race.ready\nuntil [ -f tmp/race.go ]; do sleep 0.02; done\nprintf '%s' '{}'\nexit 0"
    when "rspec_noisy_stdout"
      "case \"\$*\" in *--version*) echo '3.13.6'; exit 0;; esac\n# noisy stdout test: --out file should contain valid JSON, stdout is polluted\nOUT=\"\"; PREV=\"\"; for ARG in \"$@\"; do if [ \"$PREV\" = \"--out\" ]; then OUT=\"$ARG\"; fi; PREV=\"$ARG\"; done\nif [ -n \"$OUT\" ]; then mkdir -p \"$(dirname \"$OUT\")\"; printf '%s' '{\"version\":\"3.13.6\",\"summary\":{\"duration\":0.1,\"example_count\":1,\"failure_count\":0,\"pending_count\":0,\"errors\":0},\"examples\":[{\"description\":\"noisy passes\",\"full_description\":\"noisy passes\",\"status\":\"passed\",\"file_path\":\"./spec/models/product_spec.rb\",\"line_number\":5}]}' > \"$OUT\"; fi\nprintf '%s\\n' '[AUDIT][2026-08-26] Starting test suite'; printf '%s\\n' 'puts pollution from application initializer'; printf '%s\\n' 'JSON Coverage report generated'; exit 0"
    when "rspec_exit1_no_failures"
      "case \"\$*\" in *--version*) echo '3.13.6'; exit 0;; esac\nOUT=\"\"; PREV=\"\"; for ARG in \"$@\"; do if [ \"$PREV\" = \"--out\" ]; then OUT=\"$ARG\"; fi; PREV=\"$ARG\"; done\nif [ -n \"$OUT\" ]; then mkdir -p \"$(dirname \"$OUT\")\"; printf '%s' '{\"version\":\"3.13.6\",\"summary\":{\"duration\":0.1,\"example_count\":2,\"failure_count\":0,\"pending_count\":0,\"errors\":0},\"examples\":[{\"description\":\"t1\",\"status\":\"passed\",\"file_path\":\"./spec/sample_spec.rb\",\"line_number\":5},{\"description\":\"t2\",\"status\":\"passed\",\"file_path\":\"./spec/sample_spec.rb\",\"line_number\":10}]}' > \"$OUT\"; fi\nprintf '%s\\n' 'Failure after suite execution in after(:suite) hook' >&2; exit 1"
    when "rspec_failed_examples"
      "case \"\$*\" in *--version*) echo '3.13.6'; exit 0;; esac\nOUT=\"\"; PREV=\"\"; for ARG in \"$@\"; do if [ \"$PREV\" = \"--out\" ]; then OUT=\"$ARG\"; fi; PREV=\"$ARG\"; done\nif [ -n \"$OUT\" ]; then mkdir -p \"$(dirname \"$OUT\")\"; printf '%s' '{\"version\":\"3.13.6\",\"summary\":{\"duration\":0.1,\"example_count\":1,\"failure_count\":1,\"pending_count\":0,\"errors\":0},\"examples\":[{\"description\":\"failing example\",\"full_description\":\"failing example\",\"status\":\"failed\",\"file_path\":\"./spec/models/product_spec.rb\",\"line_number\":12,\"exception\":{\"message\":\"expected true to be false\",\"backtrace\":[\"spec/models/product_spec.rb:12:in `block (2 levels)\" ]}}]}' > \"$OUT\"; fi\nexit 1"
    when "rspec_missing_report"
      "case \"\$*\" in *--version*) echo '3.13.6'; exit 0;; esac\n# intentionally do NOT create --out file\nprintf '%s\\n' 'RSpec did not produce output' >&2; exit 1"
    when "rspec_malformed_report"
      "case \"\$*\" in *--version*) echo '3.13.6'; exit 0;; esac\nOUT=\"\"; PREV=\"\"; for ARG in \"$@\"; do if [ \"$PREV\" = \"--out\" ]; then OUT=\"$ARG\"; fi; PREV=\"$ARG\"; done\nif [ -n \"$OUT\" ]; then mkdir -p \"$(dirname \"$OUT\")\"; printf '%s' '{not-json[' > \"$OUT\"; fi\nexit 0"
    when "minitest_exit1_no_failures"
      "case \"\$*\" in *--version*) echo '5.20.0'; exit 0;; esac\n# Also handle ruby -rminitest version probes\ncase \"\$*\" in *Minitest::VERSION*) echo '5.20.0'; exit 0;; esac\nif [ -n \"$RAILVERDICT_MINITEST_OUTPUT\" ]; then mkdir -p \"$(dirname \"$RAILVERDICT_MINITEST_OUTPUT\")\"; printf '%s' '{\"schema_version\":\"1.0\",\"runner\":\"minitest 5.20.0\",\"seed\":1234,\"tests_total\":1,\"assertions\":1,\"failures\":0,\"errors\":0,\"skips\":0,\"duration_seconds\":0.05,\"tests\":[{\"class_name\":\"SampleTest\",\"method_name\":\"test_pass\",\"status\":\"passed\",\"file\":\"test/sample_test.rb\",\"line\":5}]}' > \"$RAILVERDICT_MINITEST_OUTPUT\"; fi\nexit 1"
    when "minitest_reporter_identity"
      "case \"\$*\" in *--version*) echo '5.20.0'; exit 0;; esac\ncase \"\$*\" in *Minitest::VERSION*) echo '5.20.0'; exit 0;; esac\nif [ -n \"$RAILVERDICT_MINITEST_OUTPUT\" ]; then mkdir -p \"$(dirname \"$RAILVERDICT_MINITEST_OUTPUT\")\"; printf '%s' '{\"schema_version\":\"1.0\",\"runner\":\"minitest 5.20.0\",\"seed\":1,\"tests_total\":1,\"assertions\":1,\"failures\":0,\"errors\":0,\"skips\":0,\"duration_seconds\":0.01,\"tests\":[{\"class_name\":\"IdentityTest\",\"method_name\":\"test_bound\",\"status\":\"passed\",\"file\":\"test/sample_test.rb\",\"line\":5}]}' > \"$RAILVERDICT_MINITEST_OUTPUT\"; fi\nexit 0"
    when "bundle_probe_fail"
      "case \"\$*\" in *--version*) exit 7;; esac\ncase \"\$*\" in *Minitest::VERSION*) exit 7;; esac\nexit 7"
    when "long_probe_clamp"
      "case \"\$*\" in *--version*) sleep 0.1; echo '3.13.6'; exit 0;; esac\ncase \"\$*\" in *Minitest::VERSION*) sleep 0.1; echo '5.20.0'; exit 0;; esac\nOUT=\"\"; PREV=\"\"; for ARG in \"$@\"; do if [ \"$PREV\" = \"--out\" ]; then OUT=\"$ARG\"; fi; PREV=\"$ARG\"; done\nif [ -n \"$OUT\" ]; then mkdir -p \"$(dirname \"$OUT\")\"; printf '%s' '{\"version\":\"3.13.6\",\"summary\":{\"duration\":0.01,\"example_count\":1,\"failure_count\":0,\"pending_count\":0,\"errors\":0},\"examples\":[{\"description\":\"probe clamp test\",\"status\":\"passed\",\"file_path\":\"./spec/sample_spec.rb\",\"line_number\":1}]}' > \"$OUT\"; fi\nif [ -n \"$RAILVERDICT_MINITEST_OUTPUT\" ]; then mkdir -p \"$(dirname \"$RAILVERDICT_MINITEST_OUTPUT\")\"; printf '%s' '{\"schema_version\":\"1.0\",\"runner\":\"minitest 5.20.0\",\"seed\":1,\"tests_total\":1,\"assertions\":1,\"failures\":0,\"errors\":0,\"skips\":0,\"duration_seconds\":0.01,\"tests\":[]}' > \"$RAILVERDICT_MINITEST_OUTPUT\"; fi\nexit 0"
    when "adversarial_rubocop"
      "case \"$*\" in *--version*) echo '1.88.0'; exit 0;; esac\nprintf '%s' '{\"files\":[{\"path\":\"app/models/order.rb\",\"offenses\":[{\"cop_name\":\"Layout/TrailingWhitespace\",\"severity\":\"convention\",\"message\":\"\",\"location\":{\"start_line\":1,\"last_line\":1}},{\"cop_name\":\"Style/StringLiterals\",\"severity\":\"warning\",\"message\":\"\\u001b[31mColor\\u001b[0m with \\u0000 null and \\u0007 bell\",\"location\":{\"start_line\":2,\"last_line\":2}},{\"cop_name\":\"Naming/MethodName\",\"severity\":\"convention\",\"message\":\"'$(head -c 8000 /dev/zero | tr '\\0' 'A')'\",\"location\":{\"start_line\":3,\"last_line\":3}},{\"cop_name\":\"Metrics/ClassLength\",\"severity\":\"refactor\",\"message\":\"Broken: \\ufffd\\ufffd\\ufffd\",\"location\":{\"start_line\":4,\"last_line\":4}}]}]}'; exit 1"
    when "oversized_rspec"
      "case \"$*\" in *--version*) echo '3.13.6'; exit 0;; esac\nprintf '{\"examples\":['; head -c 18000000 /dev/zero | tr '\\0' 'A'; printf ']}'; exit 1"
    when "unknown_version_rubocop"
      "case \"$*\" in *--version*) echo 'unknown-tool-output'; exit 0;; esac\nprintf '{\"files\":[]}'; exit 0"
    when "signaled"
      "case \"$*\" in *--version*) echo '1.88.0'; exit 0;; esac\nkill -TERM $$"
    when "oversized"
      "case \"$*\" in *--version*) echo '1.88.0'; exit 0;; esac\nhead -c 200000 /dev/zero; exit 0"
    when "record_reuse"
      "L=\"$PWD/..\"; echo \"$$ $*\" >> \"$L/reuse-$PPID.log\""
    else
      raise "unknown fake bundle behavior: #{behavior}"
    end
  end

  def identity(root, candidate_spec, candidate_command, candidate_env, verified:, artifact_sha: nil)
    rails = run(["bundle", "exec", "rails", "--version"], cwd: root)
    bundler = run(["bundle", "--version"], cwd: root)
    {
      "candidate" => candidate_spec,
      "resolved_command" => candidate_command,
      "verified" => verified,
      "artifact_sha256" => artifact_sha,
      "railverdict_version" => run([candidate_command, "--version"], cwd: root, env: candidate_env).first.strip,
      "ruby_version" => RUBY_VERSION,
      "rails_version" => rails.first.strip,
      "bundler_version" => bundler.first.strip,
      "os" => RbConfig::CONFIG.fetch("host_os"),
      "lab_commit" => run(["git", "rev-parse", "HEAD"], cwd: root).first.strip,
      "scenario_catalog_version" => candidate_spec.fetch("scenario_catalog_version", "2.0")
    }
  end
end

  def install_large_rspec(work_dir, count = 2000)
    spec_dir = File.join(work_dir, "spec", "models")
    FileUtils.mkdir_p(spec_dir)
    lines = ["require 'spec_helper'", "RSpec.describe 'LargeSuite' do"]
    count.times do |i|
      lines << "  it 'runs test #{i}' do"
      lines << "    expect(#{i}).to eq(#{i})"
      lines << "  end"
    end
    lines << "end"
    File.write(File.join(spec_dir, "large_suite_spec.rb"), lines.join("\n"))
  end
