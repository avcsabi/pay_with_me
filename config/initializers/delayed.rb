# frozen_string_literal: true

Delayed.logger = Logger.new($stdout)
Delayed.default_log_level = 'info'
