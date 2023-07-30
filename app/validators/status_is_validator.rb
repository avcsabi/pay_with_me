# frozen_string_literal: true

# Validates that associated object's status attribute is in the allowed list of values
class StatusIsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.respond_to?(:status) && options[:in].include?(value.status)

    record.errors.add attribute, (options[:message] || "must have status #{options[:in].join(' or ')}")
  end
end
