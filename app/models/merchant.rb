# frozen_string_literal: true

# Merchants have many payment transactions of different types
class Merchant < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :recoverable, :rememberable, :registerable
  devise :database_authenticatable, :validatable

  has_many :transactions

  validates_uniqueness_of :email, case_sensitive: false
  validates :status, inclusion: { in: %w[active inactive] }
  validates :admin, inclusion: { in: [true, false] }
  validates_presence_of :name, :status

  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }
  scope :admins, -> { where(admin: true) }

  before_destroy do
    throw :abort if transactions.count > 0
  end

  def is_active?
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
    super and is_active?
  end
end
