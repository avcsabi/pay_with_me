# frozen_string_literal: true

# Used to redirect user to a proper root page
class PassthroughController < ApplicationController
  def index
    if current_merchant
      path = current_merchant.admin? ? merchants_path : merchant_transactions_path(current_merchant)
      redirect_to path
    else
      redirect_to merchant_session_path
    end
  end
end
