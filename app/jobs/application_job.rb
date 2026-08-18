# frozen_string_literal: true

class ApplicationJob
  def self.perform_later(*args)
    new.perform(*args)
  end
end
