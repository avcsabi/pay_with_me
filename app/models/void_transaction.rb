# frozen_string_literal: true

# Void transaction - has no amount , used to invalidate the Authorize
# Transaction
class VoidTransaction < Transaction
  PARENT_TRANSITIONS_TO = 'voided'
  include Transitioning

  validates :amount, absence: true
  validate :check_parent_transaction
  validates :parent_transaction, presence: true, class_is: [AuthorizeTransaction], status_is: %w[approved]

  before_validation :set_default_status
  after_create :transition_parent

  private

  def check_parent_transaction
    # Check parent transaction referred transactions
    return if parent_transaction.nil? || parent_transaction.transactions.non_error.count.zero?

    errors.add :parent_transaction, :invalid, message: 'is referred by other transactions'
  end

  def set_default_status
    self.status ||= 'approved'
  end
end
