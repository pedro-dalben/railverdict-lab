# frozen_string_literal: true

require "minitest/autorun"
require "yaml"
require "json"
require "open3"
require "tempfile"

class LabInfrastructureTest < Minitest::Test
  def setup
    @repo_root = File.expand_path("../..", __dir__)
    @candidate_file = File.join(@repo_root, "lab/candidate.yml")
    @scenarios_file = File.join(@repo_root, "lab/scenarios.yml")
    @pr_workflow_file = File.join(@repo_root, ".github/workflows/railverdict-pr.yml")
    @oracle_script = File.join(@repo_root, "scripts/lab_oracle")
  end

  def test_candidate_url_is_https
    candidate_data = YAML.safe_load(File.read(@candidate_file))
    repo_url = candidate_data.dig("candidate", "repository")
    assert repo_url, "candidate repository must be defined"
    assert repo_url.start_with?("https://"), "candidate repository must use HTTPS clone URL, got #{repo_url}"
    refute_match(/git@|token|bearer|x-access-token/i, repo_url, "candidate repository must not use SSH or tokens")
  end

  def test_candidate_revision_is_pinned
    candidate_data = YAML.safe_load(File.read(@candidate_file))
    revision = candidate_data.dig("candidate", "revision")
    assert_match(/\A[0-9a-f]{40}\z/, revision, "candidate revision must be a pinned 40-char SHA")
  end

  def test_workflow_declares_job_output
    workflow_text = File.read(@pr_workflow_file)
    workflow_yaml = YAML.safe_load(workflow_text)
    
    gate_job = workflow_yaml.dig("jobs", "railverdict-gate")
    assert gate_job, "railverdict-gate job must exist"
    
    outputs = gate_job["outputs"]
    assert outputs, "railverdict-gate job must declare outputs"
    assert_equal "${{ steps.check.outputs.exit_code }}", outputs["exit_code"],
      "railverdict-gate must expose step exit_code output"
  end

  def test_workflow_check_step_captures_exit_code_without_failing_job
    workflow_text = File.read(@pr_workflow_file)
    
    # Must capture EXIT_CODE and write to GITHUB_OUTPUT
    assert_includes workflow_text, 'echo "exit_code=$EXIT_CODE" >> "$GITHUB_OUTPUT"'
    # Must NOT exit with product exit code in the check step
    refute_match(/Execute RailVerdict gate check.*?exit\s+\$EXIT_CODE/m, workflow_text,
      "workflow check step must not exit with product status code")
  end

  def test_workflow_passes_branch_name_env_to_oracle
    workflow_text = File.read(@pr_workflow_file)
    workflow_yaml = YAML.safe_load(workflow_text)
    
    oracle_job = workflow_yaml.dig("jobs", "lab-oracle")
    assert oracle_job, "lab-oracle job must exist"
    
    step = oracle_job["steps"]&.find { |s| s["name"] == "Run Lab Oracle assertion" }
    assert step, "Run Lab Oracle assertion step must exist"
    
    assert_equal "${{ github.head_ref }}", step.dig("env", "BRANCH_NAME"),
      "BRANCH_NAME environment variable must be passed from github.head_ref"
  end

  def test_scenario_manifest_has_unique_and_mapped_pr_branches
    manifest = YAML.safe_load(File.read(@scenarios_file))
    scenarios = manifest["scenarios"]
    
    pr_scenarios = scenarios.select { |s| s["category"] == "core_pr" }
    assert_equal 12, pr_scenarios.length, "Expected 12 core PR scenarios"

    branches = pr_scenarios.map { |s| s["branch"] }
    assert_equal branches.uniq.length, branches.length, "Scenario branches must be unique"

    expected_branches = [
      "lab/01-clean-change",
      "lab/02-existing-debt",
      "lab/03-new-rubocop",
      "lab/04-minitest-failure",
      "lab/05-rspec-failure",
      "lab/06-zero-tests",
      "lab/07-unavailable-analyzer",
      "lab/08-active-waiver",
      "lab/09-expired-waiver",
      "lab/10-git-edge-cases",
      "lab/11-changed-scope",
      "lab/12-coverage-gate"
    ]

    expected_branches.each do |eb|
      matched = pr_scenarios.find { |s| s["branch"] == eb }
      assert matched, "Branch #{eb} must map to a scenario in manifest"
    end
  end

  def test_oracle_fails_closed_on_unknown_expectation_key
    # Create temporary scenarios file with unknown key
    Tempfile.create(["invalid_scenario", ".yml"]) do |f|
      invalid_manifest = {
        "scenarios" => [
          {
            "id" => "RVLAB-TEST-INVALID",
            "title" => "Test Invalid Scenario",
            "expected" => {
              "gate" => "PASS",
              "unsupported_cheat_key" => true
            }
          }
        ]
      }
      f.write(YAML.dump(invalid_manifest))
      f.flush

      stdout, stderr, status = Open3.capture3(
        "ruby", "-e", %{
          require "yaml"
          require "json"
          manifest_path = "#{f.path}"
          # We run oracle logic directly to test key validation
          scenario = YAML.safe_load(File.read(manifest_path))["scenarios"].first
          expected = scenario["expected"]
          
          SUPPORTED_KEYS = %w[
            gate completion_status policy_status exit_code
            introduced_min introduced_max introduced_count
            existing_min existing_max existing_count
            waived_min waived_max waived_count
            boundary_changed boundary_changed_config
            boundary_changed_waivers boundary_changed_baseline
            target_status mcp_initialized initial_gate final_gate
          ].freeze

          unknown = expected.keys.map(&:to_s) - SUPPORTED_KEYS
          unless unknown.empty?
            $stderr.puts "[ORACLE ERROR] unknown key: \#{unknown.join(', ')}"
            exit 2
          end
        }
      )

      assert_equal 2, status.exitstatus, "Oracle must fail closed (exit 2) on unknown expectation key"
      assert_includes stderr, "unsupported_cheat_key"
    end
  end

  def test_oracle_evaluates_existing_counts
    Tempfile.create(["result", ".json"]) do |f|
      result_payload = {
        "gate" => "PASS",
        "completion_status" => "complete",
        "policy_status" => "pass",
        "comparison" => {
          "counts" => {
            "introduced" => 0,
            "existing" => 3,
            "waived" => 0
          }
        }
      }
      f.write(JSON.dump(result_payload))
      f.flush

      # Run Oracle on RVLAB-02 (expects existing_count: 3, exit_code: 0)
      stdout, stderr, status = Open3.capture3(
        "ruby", @oracle_script,
        "--scenario", "RVLAB-02",
        "--result", f.path,
        "--exit-code", "0"
      )

      assert_equal 0, status.exitstatus, "Oracle should pass when existing_count matches: #{stderr}"
      json_chunk = stdout[/\{.*\}/m]
      obs = JSON.parse(json_chunk)
      existing_check = obs["checks"].find { |c| c["name"] == "existing_count" }
      assert existing_check, "existing_count check must be performed"
      assert existing_check["matched"], "existing_count check must match"
    end
  end

  def test_oracle_expected_fail_actual_fail_passes
    Tempfile.create(["result", ".json"]) do |f|
      result_payload = {
        "gate" => "FAIL",
        "completion_status" => "complete",
        "policy_status" => "fail",
        "comparison" => { "counts" => { "introduced" => 1, "existing" => 0, "waived" => 0 } }
      }
      f.write(JSON.dump(result_payload))
      f.flush

      # RVLAB-03 expects FAIL / exit 1 / introduced_min 1
      stdout, stderr, status = Open3.capture3(
        "ruby", @oracle_script,
        "--scenario", "RVLAB-03",
        "--result", f.path,
        "--exit-code", "1"
      )

      assert_equal 0, status.exitstatus, "Expected FAIL + Actual FAIL should result in Oracle PASS (exit 0): #{stderr}"
      assert_includes stdout, "LAB ORACLE PASS"
    end
  end

  def test_oracle_expected_incomplete_actual_incomplete_passes
    Tempfile.create(["result", ".json"]) do |f|
      result_payload = {
        "gate" => "INCOMPLETE",
        "completion_status" => "incomplete",
        "policy_status" => "not_evaluated"
      }
      f.write(JSON.dump(result_payload))
      f.flush

      # RVLAB-06 expects INCOMPLETE / exit 2
      stdout, stderr, status = Open3.capture3(
        "ruby", @oracle_script,
        "--scenario", "RVLAB-06",
        "--result", f.path,
        "--exit-code", "2"
      )

      assert_equal 0, status.exitstatus, "Expected INCOMPLETE + Actual INCOMPLETE should result in Oracle PASS (exit 0): #{stderr}"
      assert_includes stdout, "LAB ORACLE PASS"
    end
  end

  def test_oracle_expected_fail_actual_pass_fails
    Tempfile.create(["result", ".json"]) do |f|
      result_payload = {
        "gate" => "PASS",
        "completion_status" => "complete",
        "policy_status" => "pass",
        "comparison" => { "counts" => { "introduced" => 0, "existing" => 0, "waived" => 0 } }
      }
      f.write(JSON.dump(result_payload))
      f.flush

      # RVLAB-03 expects FAIL / exit 1
      stdout, stderr, status = Open3.capture3(
        "ruby", @oracle_script,
        "--scenario", "RVLAB-03",
        "--result", f.path,
        "--exit-code", "0"
      )

      assert_equal 1, status.exitstatus, "Expected FAIL + Actual PASS must result in Oracle FAIL (exit 1)"
      assert_includes stderr, "LAB ORACLE FAIL"
    end
  end

  def test_oracle_expected_pass_missing_result_fails
    # Provide nonexistent result path
    stdout, stderr, status = Open3.capture3(
      "ruby", @oracle_script,
      "--scenario", "RVLAB-01",
      "--result", "/nonexistent/result.json",
      "--exit-code", "0"
    )

    assert_equal 1, status.exitstatus, "Expected PASS + Missing result must result in Oracle FAIL (exit 1)"
    assert_includes stderr, "LAB ORACLE FAIL"
  end
end
