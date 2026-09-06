# frozen_string_literal: true

require "fileutils"
require "json"
require "minitest/autorun"
require "open3"
require "tempfile"
require "tmpdir"
require "yaml"

# D02 trust battery: every adversarial input below must fail closed.
# Mapping: LAB-01 unknown expectation, LAB-02 absent mandatory field,
# LAB-03 strict typing, LAB-04 gate/exit independence, LAB-05 malformed JSON,
# LAB-06 empty selection/aggregation, LAB-07 uncovered capability,
# LAB-08 absent vs empty analyzer results, LAB-09 unparseable stdout,
# LAB-10 BLOCKED vs FAIL classification, LAB-11 concurrent isolation,
# LAB-12 setup failure detected before measurement, LAB-13 unconsumed
# expectations, LAB-14 detached aggregate, LAB-15 timeout with partial logs.
class LabOracleTrustTest < Minitest::Test
  def setup
    @root = File.expand_path("../..", __dir__)
  end

  def run_oracle(scenario_id, payload, exit_code)
    Tempfile.create(["lab-result", ".json"]) do |file|
      file.write(JSON.generate(payload))
      file.flush
      Open3.capture3("ruby", File.join(@root, "scripts", "lab_oracle"),
                     "--scenario", scenario_id, "--result", file.path, "--exit-code", exit_code.to_s)
    end
  end

  def run_oracle_raw(scenario_id, raw, exit_code)
    Tempfile.create(["lab-result", ".json"]) do |file|
      file.write(raw)
      file.flush
      Open3.capture3("ruby", File.join(@root, "scripts", "lab_oracle"),
                     "--scenario", scenario_id, "--result", file.path, "--exit-code", exit_code.to_s)
    end
  end

  def rvlab03_passing
    { "gate" => "FAIL", "completion_status" => "complete", "policy_status" => "fail",
      "comparison" => { "counts" => { "introduced" => 1 } },
      "findings" => [{ "state" => "introduced" }] }
  end

  def test_control_passes_with_accounting
    stdout, _stderr, status = run_oracle("RVLAB-03", rvlab03_passing, 1)
    assert status.success?
    observation = JSON.parse(stdout)
    assert_equal [], observation.fetch("unconsumed_assertions")
    assert_includes observation.fetch("evaluated_assertions"), "introduced_min"
    assert_equal [], observation.fetch("failed_assertions")
  end

  # LAB-02: removed decision never certifies.
  def test_mutant_removed_gate_is_killed
    payload = rvlab03_passing.reject { |key, _| key == "gate" }
    _stdout, _stderr, status = run_oracle("RVLAB-03", payload, 1)
    assert_equal 1, status.exitstatus
  end

  # LAB-02: inverted completion never certifies.
  def test_mutant_inverted_completion_is_killed
    _stdout, _stderr, status = run_oracle("RVLAB-03", rvlab03_passing.merge("completion_status" => "incomplete"), 1)
    assert_equal 1, status.exitstatus
  end

  # LAB-04: exit changed while gate stays correct.
  def test_mutant_changed_exit_is_killed
    _stdout, _stderr, status = run_oracle("RVLAB-03", rvlab03_passing, 0)
    assert_equal 1, status.exitstatus
  end

  # LAB-02: counts removed while gate/exit stay correct.
  def test_mutant_suppressed_counts_is_killed
    payload = rvlab03_passing.reject { |key, _| key == "comparison" || key == "findings" }
    stdout, _stderr, status = run_oracle("RVLAB-03", payload, 1)
    assert_equal 1, status.exitstatus
    observation = JSON.parse(stdout)
    assert_includes observation.fetch("failed_assertions"), "introduced_min"
  end

  # LAB-02: zero is not a favorable default on empty evidence.
  def test_empty_result_never_passes_zero_bound
    _stdout, _stderr, status = run_oracle("RVLAB-01", {}, 0)
    assert_equal 1, status.exitstatus
  end

  # LAB-03: stated string count is not an integer count.
  def test_mutant_string_count_is_killed
    payload = rvlab03_passing.merge("comparison" => { "counts" => { "introduced" => "1" } })
    _stdout, _stderr, status = run_oracle("RVLAB-03", payload, 1)
    assert_equal 1, status.exitstatus
  end

  # LAB-08: analyzer_results absent vs empty are both explicit failures.
  def test_mutant_suppressed_analyzer_is_killed
    base = { "gate" => "FAIL", "completion_status" => "complete", "policy_status" => "fail" }
    _stdout, _stderr, missing = run_oracle("RVLAB-04",
                                           base.merge("analyzer_results" => [{ "analyzer" => "minitest", "execution_status" => "succeeded" }]), 1)
    assert missing.success?, "control with present analyzer evidence must pass"
    _stdout, _stderr, absent = run_oracle("RVLAB-04", base, 1)
    assert_equal 1, absent.exitstatus
    _stdout, _stderr, empty = run_oracle("RVLAB-04", base.merge("analyzer_results" => []), 1)
    assert_equal 1, empty.exitstatus
  end

  # LAB-04: gate wrong while exit stays correct.
  def test_mutant_wrong_gate_right_exit_is_killed
    _stdout, _stderr, status = run_oracle("RVLAB-03", rvlab03_passing.merge("gate" => "PASS"), 1)
    assert_equal 1, status.exitstatus
  end

  # LAB-01/LAB-10: unknown scenario is a harness error, never a verdict.
  def test_unknown_scenario_is_harness_error
    _stdout, stderr, status = run_oracle("NOPE-00", {}, 0)
    assert_equal 2, status.exitstatus
    assert_includes stderr, "unknown scenario"
  end

  # LAB-05/LAB-10: truncated JSON is a harness error, never parsed as success.
  def test_truncated_result_is_harness_error
    _stdout, stderr, status = run_oracle_raw("RVLAB-03", '{"gate": "FAIL", "compar', 1)
    assert_equal 2, status.exitstatus
    assert_includes stderr, "not valid JSON"
  end

  # LAB-13: every declared expectation is evaluated; nothing disappears.
  def test_failed_assertions_name_missing_counts
    stdout, _stderr, status = run_oracle("RVLAB-03",
                                         rvlab03_passing.reject { |key, _| key == "comparison" || key == "findings" }, 1)
    assert_equal 1, status.exitstatus
    observation = JSON.parse(stdout)
    assert_includes observation.fetch("failed_assertions"), "introduced_min"
    check = observation.fetch("checks").find { |item| item["name"] == "introduced_min" }
    assert_equal false, check.fetch("evaluated")
  end

  # LAB-06: selecting nothing refuses to certify.
  def test_empty_selection_exits_blocked
    _stdout, stderr, status = Open3.capture3("ruby", File.join(@root, "scripts", "lab_run"), "--scenario", "NOPE-00")
    assert_equal 2, status.exitstatus
    assert_includes stderr, "No scenarios selected"
  end

  # LAB-10: installation failure is BLOCKED, never FAIL or PASS.
  def test_install_failure_is_blocked
    summary_path = File.join(@root, "artifacts", "lab-run-summary.json")
    backup = File.file?(summary_path) ? File.read(summary_path) : nil
    _stdout, stderr, status = Open3.capture3("ruby", File.join(@root, "scripts", "lab_run"),
                                             "--scenario", "RVLAB-01", "--artifact", "/nonexistent.gem")
    assert_equal 2, status.exitstatus
    assert_includes stderr, "BLOCKED"
    summary = JSON.parse(File.read(summary_path))
    assert_equal "BLOCKED", summary.fetch("status")
  ensure
    if backup.nil?
      FileUtils.rm_f(summary_path)
    else
      File.write(summary_path, backup)
    end
  end

  # LAB-11: a live holder blocks; a stale lock is reclaimed; release is owned.
  def test_scenario_lock_protocol
    require_relative "../../scripts/lab_support"
    Dir.mktmpdir do |root|
      first = LabSupport.acquire_scenario_lock(root, "X")
      assert_equal true, first.fetch("locked")
      second = LabSupport.acquire_scenario_lock(root, "X")
      assert_equal false, second.fetch("locked")
      assert_equal Process.pid.to_s, second.fetch("holder")
      LabSupport.release_scenario_lock(first)
      third = LabSupport.acquire_scenario_lock(root, "X")
      assert_equal true, third.fetch("locked")
      File.write(File.join(root, "artifacts", "X.lock", "pid"), "999999999")
      fourth = LabSupport.acquire_scenario_lock(root, "X")
      assert_equal true, fourth.fetch("locked")
      File.write(File.join(root, "artifacts", "X.lock", "pid"), "1")
      LabSupport.release_scenario_lock(fourth)
      assert File.directory?(File.join(root, "artifacts", "X.lock")), "foreign lock must survive release"
    end
  end

  # LAB-12: setup operations fail before any measurement.
  def test_setup_failures_raise_before_measurement
    require_relative "../../scripts/lab_support"
    stub = Struct.new(:command, :env).new("true", {})
    Dir.mktmpdir do |dir|
      File.write(File.join(dir, ".railverdict.yml"), "mode: no_new_debt\n")
      assert_raises(RuntimeError) do
        LabSupport.apply_operations(dir, [{ "name" => "config_replace", "from" => "absent-key", "to" => "x" }], candidate: stub, env: {})
      end
      assert_raises(RuntimeError) do
        LabSupport.apply_operations(dir, [{ "name" => "nope-unknown-op" }], candidate: stub, env: {})
      end
      identity = LabSupport.fixture_identity(dir)
      assert identity.key?("base_commit")
    end
  end

  # LAB-15: timeout kills the child, keeps partial output, flags the run.
  def test_product_run_timeout_kills_and_keeps_partial_output
    require_relative "../../scripts/lab_support"
    stub = Struct.new(:command, :env).new("sh", {})
    Dir.mktmpdir do |dir|
      stdout, _stderr, status = LabSupport.product_run(stub, ["-c", "echo part; sleep 5"], cwd: dir, timeout_seconds: 1)
      assert_equal 124, status.exitstatus
      assert_includes stdout, "part"
    end
  end

  def test_json_strict_rejects_truncated_stdout
    require_relative "../../scripts/lab_support"
    assert_raises(JSON::ParserError) { LabSupport.json_strict('{"gate": "FAIL", ') }
    assert_equal "FAIL", LabSupport.json_strict('{"gate": "FAIL"}').fetch("gate")
  end

  # LAB-06/LAB-07/LAB-14 at the aggregation layer via an isolated LAB_ROOT.
  def write_lab_root(entries, run_results: nil, artifacts: {})
    root = Dir.mktmpdir
    FileUtils.mkdir_p(File.join(root, "lab"))
    File.write(File.join(root, "lab", "candidate.yml"), File.read(File.join(@root, "lab", "candidate.yml")))
    manifest = { "schema_version" => "2.0", "catalog_version" => "9.9-test", "scenarios" => entries }
    File.write(File.join(root, "lab", "scenarios.yml"), YAML.dump(manifest))
    FileUtils.mkdir_p(File.join(root, "artifacts"))
    File.write(File.join(root, "artifacts", "lab-run-summary.json"), JSON.pretty_generate({ "results" => run_results })) unless run_results.nil?
    artifacts.each do |id, files|
      dir = File.join(root, "artifacts", id)
      FileUtils.mkdir_p(dir)
      files.each { |name, content| File.write(File.join(dir, name), content) }
    end
    root
  end

  def scenario_entry(id, capability: nil)
    entry = { "id" => id, "title" => id, "category" => "tcat", "description" => id,
              "setup" => { "strategy" => "fresh", "operations" => [] },
              "command" => { "interface" => "cli", "args" => %w[check] },
              "expected_gate" => "PASS", "expected_completion" => "complete", "expected_exit" => 0,
              "cleanup" => "none", "tags" => [] }
    entry["capability"] = capability if capability
    entry["skip_if_unsupported"] = true if capability
    entry
  end

  # LAB-07: a declared capability with no executed scenario leaves Incomplete.
  def test_uncovered_capability_is_incomplete
    root = write_lab_root([scenario_entry("T-CAP-01", capability: "fake_cap")],
                          run_results: [{ "id" => "T-CAP-01", "status" => "SKIPPED" }],
                          artifacts: { "T-CAP-01" => { "observed.json" => JSON.pretty_generate({ "status" => "SKIPPED" }) } })
    _stdout, _stderr, status = Open3.capture3({ "LAB_ROOT" => root }, "ruby", File.join(@root, "scripts", "lab_collect"))
    assert_equal 2, status.exitstatus
    summary = JSON.parse(File.read(File.join(root, "artifacts", "validation-summary.json")))
    assert_includes summary.fetch("uncovered_capabilities"), "fake_cap"
  ensure
    FileUtils.rm_rf(root)
  end

  # LAB-14: a runner PASS detached from its observation fails aggregation.
  def test_detached_aggregate_fails
    root = write_lab_root([scenario_entry("T-INT-01")],
                          run_results: [{ "id" => "T-INT-01", "status" => "PASS" }],
                          artifacts: { "T-INT-01" => {
                            "observed.json" => JSON.pretty_generate({ "gate" => "FAIL" }),
                            "lab-observation.json" => JSON.pretty_generate({ "scenario_id" => "T-INT-01", "all_matched" => false,
                                                                             "checks" => [], "unconsumed_assertions" => [] })
                          } })
    _stdout, _stderr, status = Open3.capture3({ "LAB_ROOT" => root }, "ruby", File.join(@root, "scripts", "lab_collect"))
    assert_equal 1, status.exitstatus
    summary = JSON.parse(File.read(File.join(root, "artifacts", "validation-summary.json")))
    assert_equal "VALIDATION FAIL", summary.fetch("final_verdict")
  ensure
    FileUtils.rm_rf(root)
  end

  # LAB-06: aggregating zero rows refuses to certify.
  def test_empty_aggregation_is_blocked
    root = write_lab_root([])
    _stdout, stderr, status = Open3.capture3({ "LAB_ROOT" => root }, "ruby", File.join(@root, "scripts", "lab_collect"))
    assert_equal 2, status.exitstatus
    assert_includes stderr, "empty campaign"
  ensure
    FileUtils.rm_rf(root)
  end
end
