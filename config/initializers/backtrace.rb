# frozen_string_literal: true

def error_with_bt(err, backtrace_lines = 2)
  "#{err} (#{Rails.backtrace_cleaner.clean(err.backtrace)[0..(backtrace_lines - 1)].join('; ')})"
end
