# frozen_string_literal: true

if ARGV.include?("--version") || $0.to_s.end_with?("--version")
  require "minitest"
  puts "minitest #{Minitest::VERSION}"
  exit 0
end

ENV["RAILS_ENV"] ||= "test"

# Coverage setup: Generate coverage/coverage.json in RailVerdict v1 schema
require "simplecov"
SimpleCov.start do
  enable_coverage :line
  skip "/test/"
  skip "/spec/"
  skip "/config/"
  skip "/db/"
end

require_relative "../config/environment"
require "rails/test_help"
require "json"

# Load database schema into in-memory sqlite
ActiveRecord::Schema.verbose = false
load Rails.root.join("db/schema.rb")

class ActiveSupport::TestCase
  fixtures :all rescue nil
end

# Custom Minitest Reporter to format output matching minitest-reporter-v1
class RailVerdictTestReporter < Minitest::AbstractReporter
  def initialize(io = $stdout)
    super()
    @io = io
    @results = []
    @start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  def record(result)
    status = if result.skipped?
               "skipped"
             elsif result.error?
               "errored"
             elsif result.failure
               "failed"
             else
               "passed"
             end

    entry = {
      "class_name" => result.klass.to_s,
      "method_name" => result.name.to_s,
      "status" => status,
      "time_seconds" => result.time.to_f.round(6)
    }

    if (failure = result.failure)
      entry["failure_message"] = failure.message.to_s.encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: "?")[0, 4096]
      entry["failure_class"] = failure.class.name.to_s.encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: "?")[0, 256]
      loc = failure.location.to_s
      captures = loc.match(/\A(.+):(\d+)(\z|:\d+:\z)/)&.captures
      file = captures && captures[0]
      line_str = captures && captures[1]
      if file && line_str
        line = Integer(line_str, 10) rescue nil
        if line && line >= 1
          clean_file = file.sub(%r{\A#{Regexp.escape(Rails.root.to_s)}/}, "").encode(Encoding::UTF_8, invalid: :replace, undef: :replace, replace: "?")[0, 1024]
          entry["file"] = clean_file
          entry["line"] = line
        end
      end
    end

    @results << entry
  end

  def report
    duration = (Process.clock_gettime(Process::CLOCK_MONOTONIC) - @start_time).round(6)
    failures = @results.count { |r| r["status"] == "failed" }
    errors = @results.count { |r| r["status"] == "errored" }
    skips = @results.count { |r| r["status"] == "skipped" }
    assertions = @results.count { |r| %w[passed failed errored].include?(r["status"]) }
    @results.sort_by! { |t| [t["class_name"], t["method_name"]] }

    doc = {
      "schema_version" => "1.0",
      "runner" => "minitest #{Minitest::VERSION}",
      "seed" => (Minitest.respond_to?(:seed) ? Minitest.seed : 42),
      "tests_total" => @results.length,
      "assertions" => assertions,
      "failures" => failures,
      "errors" => errors,
      "skips" => skips,
      "duration_seconds" => duration,
      "tests" => @results
    }

    # Emit JSON directly when run under RailVerdict
    @io.puts JSON.generate(doc)

    # Also emit coverage in public coverage-v1 format
    write_coverage_json
  end

  def passed?
    @results.none? { |r| r["status"] == "failed" || r["status"] == "errored" }
  end

  private

  def write_coverage_json
    cov_result = SimpleCov.result
    files_data = cov_result.files.map do |file|
      rel_path = file.project_filename
      lines = file.lines.map { |l| l.covered? ? 1 : (l.missed? ? 0 : nil) }
      {
        "filename" => rel_path,
        "coverage" => { "lines" => lines }
      }
    end

    coverage_doc = {
      "version" => "1.0",
      "timestamp" => Time.now.to_i,
      "command_name" => "Minitest",
      "files" => files_data
    }

    FileUtils.mkdir_p(Rails.root.join("coverage"))
    File.write(Rails.root.join("coverage/coverage.json"), JSON.generate(coverage_doc))
  rescue StandardError
    # Non-fatal if coverage formatting fails
  end
end

if $0.to_s.end_with?("run") || ARGV.include?("run") || ENV["RAILVERDICT_MINITEST_RUN"]
  # Auto-require all test files
  Dir[Rails.root.join("test/**/*_test.rb")].sort.each { |f| require f }

  # Configure Minitest extensions to solely use RailVerdictTestReporter
  module Minitest
    def self.plugin_railverdict_init(options)
      self.reporter.reporters.clear
      self.reporter << RailVerdictTestReporter.new($stdout)
    end
    def self.plugin_railverdict_options(opts, options); end
  end
  Minitest.extensions << :railverdict
end
