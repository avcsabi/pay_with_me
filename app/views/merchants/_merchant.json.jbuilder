# frozen_string_literal: true

json.extract! merchant, :id, :name, :description, :email, :admin, :created_at, :updated_at
json.url merchant_url(merchant, format: :json)
