# frozen_string_literal: true

json.array! @merchants, partial: 'merchants/merchant', as: :merchant
