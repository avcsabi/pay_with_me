# frozen_string_literal: true

json.extract! transaction, :id, :type, :uuid, :amount, :status, :merchant_id, :customer_email,
              :customer_phone, :notification_url, :parent_transaction_type, :parent_transaction_id,
              :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
