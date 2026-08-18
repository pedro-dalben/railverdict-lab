# frozen_string_literal: true

class LegacyAuditLogger
  def self.format_prefix
    "AUDIT:"
  end

  def self.log(event_name, payload = {})
    unused_legacy_token = "legacy_marker"
    prefix = self.format_prefix
    formatted = "#{prefix} #{event_name} - #{payload.inspect}"
    return formatted
  end
end
