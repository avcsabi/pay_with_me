# frozen_string_literal: true

# Refund transaction - has amount and used to reverse the whole
# captured amount or part of the captured amount of the Capture
# Transaction and return it to the customer
class RefundTransaction < Transaction
  PARENT_TRANSITIONS_TO = 'refunded'
  include Transitioning

  validates :amount, :parent_transaction, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :parent_transaction, class_is: [CaptureTransaction], status_is: %w[approved refunded]
  validate :check_refunded_amount

  before_validation :set_default_status
  after_create :transition_parent

  private

  def check_refunded_amount
    return unless parent_transaction

    # Check total refunded amount
    total_refunded_amount = parent_transaction.total_refunded_amount
    return unless total_refunded_amount + amount > parent_transaction.amount

    errors.add :amount, :invalid, message: 'Total refunded amount is higher than the captured amount'
  end

  def set_default_status
    self.status ||= 'approved'
  end
end
