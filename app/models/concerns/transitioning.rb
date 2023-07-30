# frozen_string_literal: true

# Handles transitioning transactions
# Encapsulate some logic in a module
module Transitioning
  extend ActiveSupport::Concern

  included do
    attr_accessor :visible_to

    def transition_parent
      return if parent_transaction.nil? || !approved?

      parent_transaction.status = self.class::PARENT_TRANSITIONS_TO
      parent_transaction.save validate: false
    end
  end
end
