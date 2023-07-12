# frozen_string_literal: true

# Get HTML class to be used by Bootstrap alerts
module ApplicationHelper
  def flash_class(level)
    {
      success: 'alert-success',
      error: 'alert-danger',
      notice: 'alert-info',
      alert: 'alert-danger',
      warn: 'alert-warning'
    }[level.to_sym] || 'alert-info'
  end
end
