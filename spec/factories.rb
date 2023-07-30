# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    name { 'Active Merchant' }
    description { 'Active Merchant description' }
    email { Faker::Internet.email }
    admin { false }
    password { Faker::Internet.password }
  end

  factory :merchant_inactive, class: 'Merchant' do
    name { 'Inactive merchant' }
    description { 'Inactive merchant description' }
    email { Faker::Internet.email }
    admin { false }
    password { Faker::Internet.password }
    status { 'inactive' }
  end

  factory :admin, class: 'Merchant' do
    name { 'MyAdmin' }
    description { 'MyAdmin' }
    email { Faker::Internet.email }
    admin { true }
    password { Faker::Internet.password }
  end

  factory :authorize_transaction do
    uuid { SecureRandom.uuid }
    amount { rand(9_999_999) / 100.0 }
    status { 'approved' }
    merchant
    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.phone_number }
    notification_url { Faker::Internet.url }
  end

  factory :capture_transaction do
    uuid { SecureRandom.uuid }
    amount { rand(999_999) / 100.0 }
    status { 'approved' }
    merchant
    parent_transaction factory: :authorize_transaction
    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.phone_number }
  end

  factory :refund_transaction do
    uuid { SecureRandom.uuid }
    amount { rand(99_999) / 100.0 }
    status { 'approved' }
    merchant
    parent_transaction factory: :capture_transaction
    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.phone_number }
  end

  factory :void_transaction do
    uuid { SecureRandom.uuid }
    status { 'approved' }
    merchant
    parent_transaction factory: :authorize_transaction
    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.phone_number }
  end
end
