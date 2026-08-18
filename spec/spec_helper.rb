# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require "simplecov"
SimpleCov.start do
  enable_coverage :line
  skip "/test/"
  skip "/spec/"
  skip "/config/"
  skip "/db/"
end

require_relative "../config/environment"

# Load database schema
ActiveRecord::Schema.verbose = false
load Rails.root.join("db/schema.rb")

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random

  config.after(:suite) do
    # Write coverage in public coverage-v1 format
    begin
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
        "command_name" => "RSpec",
        "files" => files_data
      }

      FileUtils.mkdir_p(Rails.root.join("coverage"))
      File.write(Rails.root.join("coverage/coverage.json"), JSON.generate(coverage_doc))
    rescue StandardError
      nil
    end
  end
end
