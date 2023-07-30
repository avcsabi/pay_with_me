# frozen_string_literal: true

# Transaction: uuid , amount , status (approved, captured, voided,
# refunded, error), customer_email , customer_phone , notification_url
class Transaction < ApplicationRecord
  STATUSES = %w[approved declined captured voided refunded error pending].freeze
  TYPES = %w[AuthorizeTransaction CaptureTransaction RefundTransaction VoidTransaction].freeze
  ALLOWED_RESPONSE_ATTRS = %w[type uuid amount status merchant_id
                              customer_email customer_phone notification_url created_at].freeze

  belongs_to :merchant
  belongs_to :parent_transaction, optional: true, polymorphic: true
  has_many :transactions, as: :parent_transaction, dependent: :destroy

  validates :status, inclusion: { in: STATUSES }
  validates :type, :merchant, presence: true
  validates :customer_email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :uuid, uuid: true

  before_validation :generate_uuid

  scope :approved_or_refunded, -> { where(type: CaptureTransaction.name, status: %w[approved refunded]) }
  scope :refunds, -> { where(type: RefundTransaction.name, status: 'approved') }
  scope :sort_and_preload, -> { order(created_at: :desc).preload(:merchant, :transactions, :parent_transaction) }
  scope :filter_non_admin, ->(merchant) { merchant.admin? ? all : where(merchant_id: merchant) }
  scope :non_error, -> { where.not(status: 'error') }

  # Demonstrate meta-programming by generating/defining similar predicate
  # methods
  STATUSES.each do |status|
    define_method "#{status}?" do
      status == self.status
    end
  end

  # This is the factory method
  # @param [Object] params transaction will be created using these
  # @param [Object] current_merchant transaction will be created for this merchant
  # @return [Hash] a Hash with the created transaction, key :transaction if created and
  #   the validation errors if any with key :errors
  def self.create_from_params(params, current_merchant)
    return { errors: { base: ['Invalid transaction type'] } } unless TYPES.include?(params[:type])

    parent_transaction_uuid = params.delete(:parent_transaction_uuid)
    transaction = current_merchant.transactions.new(params)
    transaction.init_parent parent_transaction_uuid # will add to errors if parent not found

    transaction.status = 'error' unless transaction.errors.blank? && transaction.valid?
    transaction.save validate: false
    { transaction: transaction.allowed_response_attrs, errors: transaction.errors.presence }.compact
  end

  def init_parent(parent_uuid)
    return if parent_uuid.blank?

    self.parent_transaction = merchant.transactions.find_by(uuid: parent_uuid)
    return if parent_transaction

    valid? # will run callbacks
    errors.add :parent_transaction, :invalid, message: 'not found'
  end

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def allowed_response_attrs
    attrs = attributes.slice(*ALLOWED_RESPONSE_ATTRS)
    attrs[:parent_transaction_uuid] = parent_transaction.uuid if parent_transaction
    attrs
  end
end
