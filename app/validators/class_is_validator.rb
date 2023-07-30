# frozen_string_literal: true

# Validates that attribute's class is in the allowed list of classes
class ClassIsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if options[:in].any? { |klass| value.is_a?(klass) }

    record.errors.add attribute, (options[:message] || "must be a #{options[:in].map(&:to_s).join(' or a ')}")
  end
end
