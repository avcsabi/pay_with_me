# frozen_string_literal: true

# Capture transaction - has amount and used to confirm the whole
# authorized amount or part of the authorized amount is taken from the
# customer's account and transferred to the merchant
class CaptureTransaction < Transaction
  PARENT_TRANSITIONS_TO = 'captured'
  include Transitioning

  validates_presence_of :amount, :parent_transaction
  validates_numericality_of :amount, greater_than: 0
  validate :check_parent_transaction

  before_validation :set_default_status
  after_create :transition_parent

  def total_refunded_amount
    # Calculate total refunded amount
    total = 0
    transactions.refunds.each do |refund|
      total += refund.amount
    end
    total
  end

  private

  def check_parent_transaction
    # Check parent transaction type
    unless parent_transaction.is_a?(AuthorizeTransaction)
      errors.add :base, :invalid, message: 'Parent transaction must be an AuthorizeTransaction'
      return
    end
    # Check parent transaction status
    unless parent_transaction.approved? || parent_transaction.captured?
      errors.add :base, :invalid, message: 'Parent transaction must be approved or captured'
      return
    end
    # Check total amount
    total_captured_amount = parent_transaction.total_captured_amount
    return unless total_captured_amount + amount > parent_transaction.amount

    errors.add :amount, :invalid, message: 'Total captured amount is higher than the authorized amount'
  end

  def set_default_status
    self.status ||= 'approved'
  end
end
