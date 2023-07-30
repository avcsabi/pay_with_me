# frozen_string_literal: true

module Api
  # Add a merchant API call to generate a JWT token based on the merchant credentials
  class MerchantsController < BaseController
    skip_before_action :authenticate!, only: [:jwt_token]

    # Generate JWT token from user's email and password
    def jwt_token
      merchant_email = params[:email].presence
      merchant = merchant_email && Merchant.find_by(email: merchant_email)
      if merchant&.valid_password?(params[:password]) # call Devise to check password
        token = JsonWebTokenService.encode({ id: merchant.id }, expires: 24.hours.from_now)
        render json: { auth_token: token }
      else
        render json: { error: 'Wrong email or password' }, status: :unauthorized
      end
    end
  end
end
