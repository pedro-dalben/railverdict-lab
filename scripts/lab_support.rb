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

  def product_run(candidate, args, cwd:, extra_env: {})
    env = candidate.env.merge(extra_env)
    gemfile = File.join(cwd, "Gemfile")
    env["BUNDLE_GEMFILE"] = gemfile if File.file?(gemfile)
    run([candidate.command, *args], cwd: cwd, env: env)
  end

  def clone_fixture(repo_root, work_dir, branch: nil)
    FileUtils.rm_rf(work_dir)
    FileUtils.mkdir_p(File.dirname(work_dir))
    _stdout, stderr, status = run(["git", "clone", "--quiet", "file://#{repo_root}", work_dir], cwd: repo_root)
    raise "fixture clone failed: #{stderr}" unless status.success?

    git(work_dir, "config", "user.email", "lab@example.invalid")
    git(work_dir, "config", "user.name", "RailVerdict Lab")
    _stdout, stderr, status = git(work_dir, "branch", "main", "HEAD")
    raise "fixture base branch failed: #{stderr}" unless status.success?
    return unless branch

    _stdout, stderr, status = git(work_dir, "checkout", "-b", branch)
    raise "fixture branch failed: #{stderr}" unless status.success?
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
      when "config_replace"
        path = File.join(work_dir, ".railverdict.yml")
        File.write(path, File.read(path).sub(operation.fetch("from"), operation.fetch("to")))
      when "remove_dependency"
        gem_name = operation.fetch("gem")
        gemfile = File.join(work_dir, "Gemfile")
        File.write(gemfile, File.readlines(gemfile).reject { |line| line.include?("gem \"#{gem_name}\"") }.join)
        run(["bundle", "lock", "--remove", gem_name], cwd: work_dir)
      when "fake_bundle"
        install_fake_bundle(work_dir, operation)
        env["PATH"] = "#{File.join(work_dir, "tmp", "fake-bin")}:#{ENV.fetch("PATH", "")}".freeze
      when "commit"
        commit(work_dir, operation.fetch("message", "scenario change"))
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
    script = <<~SH
      #!/bin/sh
      if printf '%s\n' "$*" | grep -q -- '#{operation.fetch("analyzer", "rubocop")}' ; then
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
    when "unexpected_exit"
      "printf '%s' '{}'; exit 3"
    when "malformed_json"
      "printf '%s' '{not-json'; exit 0"
    when "missing_json"
      "printf '%s' '{}'; exit 0"
    when "timeout"
      "sleep 0.25; printf '%s' '{}'; exit 0"
    when "signaled"
      "kill -TERM $$"
    when "oversized"
      "head -c 200000 /dev/zero; exit 0"
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
