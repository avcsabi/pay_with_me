# frozen_string_literal: true

# Refund transaction - has amount and used to reverse the whole
# captured amount or part of the captured amount of the Capture
# Transaction and return it to the customer
class RefundTransaction < Transaction
  PARENT_TRANSITIONS_TO = 'refunded'
  include Transitioning

  validates_presence_of :amount
  validates_numericality_of :amount, greater_than: 0
  validate :check_parent_transaction

  before_validation :set_default_status
  after_create :transition_parent

  private

  def check_parent_transaction
    # Check parent transaction type
    unless parent_transaction.is_a?(CaptureTransaction)
      errors.add :base, :invalid, message: 'Parent transaction must be a CaptureTransaction'
      return
    end
    # Check parent transaction status
    unless parent_transaction.approved? || parent_transaction.refunded?
      errors.add :base, :invalid, message: 'Parent transaction must be approved or refunded'
      return
    end
    # Check total amount
    total_refunded_amount = parent_transaction.total_refunded_amount
    return unless total_refunded_amount + amount > parent_transaction.amount

    errors.add :amount, :invalid, message: 'Total refunded amount is higher than the captured amount'
  end

  def set_default_status
    self.status ||= 'approved'
  end
end
