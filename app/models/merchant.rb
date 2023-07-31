# frozen_string_literal: true

# Merchants have many payment transactions of different types
class Merchant < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :recoverable, :rememberable, :registerable
  devise :database_authenticatable, :validatable

  has_many :transactions, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }
  validates :status, inclusion: { in: %w[active inactive] }
  validates :admin, inclusion: { in: [true, false] }
  validates :name, :status, presence: true

  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }
  scope :admins, -> { where(admin: true) }
  scope :filter_non_admin, ->(merchant) { merchant.admin? ? all : where(id: merchant) }

  before_destroy :check_transactions, prepend: true

  def active?
    status == 'active'
  end

  def name_and_email
    "#{name} (#{email})"
  end

  # This method is called by devise to check for "active" state of the model
  def active_for_authentication?
    # Remember to call the super
    # then put our own check to determine "active" state using
    # our own "is_active" column
    super and active?
  end

  def check_transactions
    return unless transactions.count >= 1

    errors.add :base, 'Merchant cannot be deleted because it has transactions'
    throw(:abort)
  end

  def recent_transactions
    recent = transactions.where('updated_at >= ?', 1.year.ago).limit(10).order(updated_at: :desc)
                         .preload(parent_transaction: :parent_transaction)
    recent.map { |rec| rec.root_transaction.related_transactions(include_self: true) }.flatten
  end
end
