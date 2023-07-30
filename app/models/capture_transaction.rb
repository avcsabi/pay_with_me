# frozen_string_literal: true

# Capture transaction - has amount and used to confirm the whole
# authorized amount or part of the authorized amount is taken from the
# customer's account and transferred to the merchant
class CaptureTransaction < Transaction
  PARENT_TRANSITIONS_TO = 'captured'
  include Transitioning

  validates :amount, :parent_transaction, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :parent_transaction, class_is: [AuthorizeTransaction], status_is: %w[approved captured]
  validate :check_captured_amount

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

  def check_captured_amount
    return unless parent_transaction

    # Check total amount
    total_captured_amount = parent_transaction.total_captured_amount
    return unless total_captured_amount + amount > parent_transaction.amount

    errors.add :amount, :invalid, message: 'Total captured amount is higher than the authorized amount'
  end

  def set_default_status
    self.status ||= 'approved'
  end
end
