# frozen_string_literal: true

# AuthorizeTransaction has amount and notification_url, used
# to hold customer's amount
class AuthorizeTransaction < Transaction
  HIERARCHY_LEVEL = 0
  validates :amount, :notification_url, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validate :parent_transaction_blank

  before_validation :set_default_status
  after_create :enq_transit_job

  def total_captured_amount
    # Calculate total captured amount
    total = 0
    transactions.approved_or_refunded.each do |capture|
      total += capture.amount
      capture.transactions.refunds.each do |refund|
        total -= refund.amount
      end
    end
    total
  end

  private

  def set_default_status
    self.status ||= 'pending'
  end

  def parent_transaction_blank
    return if parent_transaction.nil?

    errors.add :base, :invalid, message: 'Must not have a parent transaction'
  end

  def enq_transit_job
    TransitPendingTransJob.perform_later(transaction_id: id)
  end
end
