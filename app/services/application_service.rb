# frozen_string_literal: true

# Base class for service objects
class ApplicationService
  def self.call(*args, &block)
    # new's args are for Notifier or alike
    # noinspection RubyArgCount
    new(*args, &block).call
  end
end
