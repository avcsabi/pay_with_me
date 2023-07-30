# frozen_string_literal: true

module Api
  # Accepts payments using XML / JSON API (single point POST request)
  class TransactionsController < BaseController
    respond_to :xml, :json
    skip_before_action :authenticate!, only: [:notification_to_file] # notification_to_file is for testing purposes

    # POST /transactions.xml or /transactions.json
    def create
      response = Transaction.create_from_params(transaction_params, current_merchant)
      http_status = response[:transaction] ? :created : :unprocessable_entity
      render_response response, http_status
    end

    # for testing purposes
    def notification_to_file
      keys = %i[unique_id amount status]
      notification_params = params.slice(*keys).permit(*keys)
      respond_to do |format|
        format.json { render json: notification_params, status: :ok }
        format.xml { render xml: notification_params, status: :ok }
      end
      File.write File.join('tmp', "notification_#{params[:status]}_#{params[:unique_id]}.json"),
                 notification_params.to_json
    end

    private

    def render_response(response, http_status)
      respond_to do |format|
        format.json { render json: response, status: http_status }
        format.xml { render xml: response, status: http_status }
      end
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      attrs = %i[
        type amount customer_email
        customer_phone notification_url parent_transaction_uuid
      ]
      params.slice(*attrs).permit(*attrs)
    end
  end
end
