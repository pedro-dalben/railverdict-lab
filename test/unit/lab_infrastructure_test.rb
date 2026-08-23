# frozen_string_literal: true

require "json"
require "minitest/autorun"
require "open3"
require "tempfile"
require "yaml"

class LabInfrastructureTest < Minitest::Test
  def setup
    @root = File.expand_path("../..", __dir__)
    @manifest = YAML.safe_load(File.read(File.join(@root, "lab", "scenarios.yml")), aliases: true)
    @candidate = YAML.safe_load(File.read(File.join(@root, "lab", "candidate.yml")), aliases: true)
  end

  def run_oracle(scenario_id, payload, exit_code)
    Tempfile.create(["lab-result", ".json"]) do |file|
      file.write(JSON.generate(payload))
      file.flush
      Open3.capture3("ruby", File.join(@root, "scripts", "lab_oracle"), "--scenario", scenario_id, "--result", file.path, "--exit-code", exit_code.to_s)
    end
  end

  def test_candidate_is_an_exact_published_package_contract
    candidate = @candidate.fetch("candidate")
    assert_equal "published", candidate.fetch("mode")
    assert_equal 64, candidate.fetch("gem_sha256").length
    assert_match(/\A[0-9a-f]{64}\z/, candidate.fetch("gem_sha256"))
    assert_nil candidate.fetch("source_sha")
  end

  def test_catalog_is_versioned_and_complete
    assert_equal "2.0", @manifest.fetch("schema_version")
    assert_operator @manifest.fetch("scenarios").length, :>=, 50
    ids = @manifest.fetch("scenarios").map { |scenario| scenario.fetch("id") }
    assert_equal ids.uniq.length, ids.length
    @manifest.fetch("scenarios").each do |scenario|
      %w[id title category description setup command expected_gate expected_completion expected_exit cleanup tags].each do |key|
        assert scenario.key?(key), "#{scenario['id']} missing #{key}"
      end
    end
  end

  def test_refusal_matrix_declares_semantic_and_process_expectations
    refusal = @manifest.fetch("scenarios").select { |scenario| scenario["category"] == "refusal" }
    assert_operator refusal.length, :>=, 14
    refusal.each do |scenario|
      assert_equal "INCOMPLETE", scenario.fetch("expected_gate"), scenario["id"]
      assert_equal "incomplete", scenario.fetch("expected_completion"), scenario["id"]
      assert_equal 2, scenario.fetch("expected_exit"), scenario["id"]
    end
  end

  def test_oracle_self_test
    stdout, stderr, status = Open3.capture3("ruby", File.join(@root, "scripts", "lab_oracle"), "--self-test")
    assert status.success?, "#{stdout}\n#{stderr}"
    assert_includes stdout, "oracle self-test: PASS"
  end

  def test_oracle_accepts_expected_fail
    stdout, stderr, status = run_oracle("RVLAB-03", { "gate" => "FAIL", "completion_status" => "complete", "policy_status" => "fail", "comparison" => { "counts" => { "introduced" => 1 } } }, 1)
    assert status.success?, "#{stdout}\n#{stderr}"
  end

  def test_oracle_accepts_expected_incomplete
    stdout, stderr, status = run_oracle("RVLAB-06", { "gate" => "INCOMPLETE", "completion_status" => "incomplete", "policy_status" => "not_evaluated" }, 2)
    assert status.success?, "#{stdout}\n#{stderr}"
  end

  def test_oracle_rejects_false_pass_for_refusal
    _stdout, stderr, status = run_oracle("RVLAB-06", { "gate" => "PASS", "completion_status" => "complete", "policy_status" => "pass" }, 0)
    assert_equal 1, status.exitstatus, stderr
  end

  def test_scripts_do_not_reference_railverdict_ruby_internals
    scripts = Dir[File.join(@root, "scripts", "*")].select { |path| File.file?(path) }
    scripts.each do |path|
      source = File.read(path)
      refute_match(/RailVerdict::|require [\"']rail_verdict/, source, path)
    end
  end

  def test_public_runner_exposes_scenario_and_category_selection
    source = File.read(File.join(@root, "scripts", "lab_run"))
    assert_includes source, "--scenario ID"
    assert_includes source, "--category NAME"
    assert_includes source, "--all"
    assert_includes source, "cli_sarif"
    assert_includes source, "explain"
    assert_includes source, "investigate"
  end

  def test_category_reports_are_scoped_to_the_current_run
    source = File.read(File.join(@root, "scripts", "lab_collect"))
    assert_includes source, "selected_scenarios"
    assert_includes source, "run_results.key?"
  end
end
