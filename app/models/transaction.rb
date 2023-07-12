# frozen_string_literal: true

# Transaction: uuid , amount , status (approved, captured, voided,
# refunded, error), customer_email , customer_phone , notification_url
class Transaction < ApplicationRecord
  STATUSES = %w[approved declined captured voided refunded error pending].freeze
  TYPES = %w[AuthorizeTransaction CaptureTransaction RefundTransaction VoidTransaction].freeze

  belongs_to :merchant
  belongs_to :parent_transaction, optional: true, polymorphic: true
  has_many :transactions, as: :parent_transaction

  validates :status, inclusion: { in: STATUSES }
  validates_presence_of :type, :merchant
  validates :customer_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :uuid, uuid: true

  before_validation :generate_uuid

  scope :approved_or_refunded, -> { where(type: CaptureTransaction.name, status: %w[approved refunded]) }
  scope :refunds, -> { where(type: RefundTransaction.name, status: 'approved') }

  # Demonstrate meta-programming by generating/defining similar predicate
  # methods
  STATUSES.each do |status|
    define_method "#{status}?" do
      status == self.status
    end
  end

  # This is the factory method
  def self.create_from_params(params, current_merchant)
    unless TYPES.include?(params[:type])
      return nil, base: 'Invalid transaction type'
    end

    parent_transaction_uuid = params.delete(:parent_transaction_uuid)
    transaction = Transaction.new(params)
    transaction.merchant = current_merchant
    if parent_transaction_uuid.present?
      parent_transaction = Transaction.find_by(merchant_id: current_merchant.id, uuid: parent_transaction_uuid)
      unless parent_transaction
        transaction.valid?
        transaction.status = 'error'
        transaction.save validate: false
        return transaction, base: 'Parent transaction not found'
      end
      transaction.parent_transaction = parent_transaction
    end
    if transaction.valid?
      if transaction.save
        [transaction, nil]
      else
        [transaction, { base: 'Error saving transaction' }]
      end
    else
      errors = transaction.errors.dup
      transaction.status = 'error'
      transaction.save validate: false
      [transaction, errors]
    end
  end

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
