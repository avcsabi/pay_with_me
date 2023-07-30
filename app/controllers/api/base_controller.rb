# frozen_string_literal: true

module Api
  # Base controller for API classes, for authentication and to have a current_merchant
  class BaseController < ActionController::API
    include ActionController::MimeResponds

    # JWT auth credits:
    #   - Tejal Panjwani, https://tejal-panjwani.medium.com/api-authentication-with-rails-cf5c410c78ed
    #   - https://github.com/rjurado01/rails_jwt_auth/tree/master

    # By default all actions need authentication
    before_action :authenticate!

    protected

    attr_reader :current_merchant, :jwt_payload

    def signed_in?
      current_merchant != nil
    end

    def authenticate!
      begin
        @jwt_payload = JsonWebTokenService.decode(jwt_from_request)
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        return render_unauthorized
      end
      merchant_id = @jwt_payload.is_a?(Hash) ? @jwt_payload['id'] : nil
      @current_merchant = merchant_id && Merchant.find_by(id: merchant_id)
      return render_unauthorized unless @current_merchant

      render_unauthorized unless @current_merchant.active?
    end

    private

    def jwt_from_request
      request.env['HTTP_AUTHORIZATION']&.split&.last
    end

    def render_unauthorized
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end
end
