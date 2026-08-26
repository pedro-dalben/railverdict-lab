#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"

class LabMCPClient
  attr_reader :trace

  def initialize(command:, env:, repository_root:)
    @trace = []
    @next_id = 0
    @stdin, @stdout, @stderr, @wait_thread = Open3.popen3(
      LabSupport.fixture_env(env, repository_root),
      command,
      "mcp",
      "serve",
      "--repository-root",
      repository_root
    )
  end

  def request(method, params = {})
    @next_id += 1
    request = { "jsonrpc" => "2.0", "id" => @next_id, "method" => method, "params" => params }
    @stdin.puts(JSON.generate(request))
    @stdin.flush
    line = @stdout.gets
    unless line
      err = @stderr.read rescue ""
      raise "MCP server closed stdout while handling #{method}; stderr=#{err[0,2000].inspect}"
    end

    response = JSON.parse(line)
    @trace << { "method" => method, "params" => params, "response" => response }
    response
  end

  def tool(name, arguments = {})
    response = request("tools/call", "name" => name, "arguments" => arguments)
    result = response.fetch("result", {})
    text = result.fetch("content", []).find { |item| item["type"] == "text" }&.fetch("text", "")
    parsed = JSON.parse(text)
    parsed.merge("mcp_is_error" => result["isError"] == true)
  rescue JSON::ParserError
    { "mcp_is_error" => true, "raw_text" => text }
  end

  def close
    @stdin.close unless @stdin.closed?
    @stdout.close unless @stdout.closed?
    @stderr.close unless @stderr.closed?
    @wait_thread.kill unless @wait_thread.join(0.1)
  rescue IOError
    nil
  end
end
