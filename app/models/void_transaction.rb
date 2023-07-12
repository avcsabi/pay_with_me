# frozen_string_literal: true

# Void transaction - has no amount , used to invalidate the Authorize
# Transaction
class VoidTransaction < Transaction
  PARENT_TRANSITIONS_TO = 'voided'
  include Transitioning

  validate :amount_nil
  validate :check_parent_transaction

  before_validation :set_default_status
  after_create :transition_parent

  private

  def check_parent_transaction
    # Check parent transaction type
    unless parent_transaction.is_a?(AuthorizeTransaction)
      errors.add :base, :invalid, message: 'Parent transaction must be an AuthorizeTransaction'
      return
    end
    # Check parent transaction status
    unless parent_transaction.approved?
      errors.add :base, :invalid, message: 'Parent transaction must be approved'
    end
    # Check parent transaction referred transactions
    return if parent_transaction.transactions.blank?

    errors.add :base, :invalid, message: 'Parent transaction is referred by other transactions'
  end

  def amount_nil
    return if amount.nil?

    errors.add :amount, :invalid, message: 'Must not have an amount'
  end

  def set_default_status
    self.status ||= 'approved'
  end
end
