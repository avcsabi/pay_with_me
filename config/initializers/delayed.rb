# frozen_string_literal: true

Delayed.logger = Logger.new(STDOUT)
Delayed.default_log_level = 'info'
