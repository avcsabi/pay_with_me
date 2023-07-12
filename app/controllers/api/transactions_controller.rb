# frozen_string_literal: true

module Api
  # Accepts payments using XML / JSON API (single point POST request)
  class TransactionsController < BaseController
    respond_to :xml, :json
    skip_before_action :authenticate!, only: [:echo]

    def authorize_transaction_count
      at_count = AuthorizeTransaction.count
      render json: { authorize_transaction_count: at_count }, status: :ok
    end

    # POST /transactions.xml or /transactions.json
    def create
      transaction, errors = Transaction.create_from_params(transaction_params, current_merchant)
      response = {}
      response[:errors] = errors unless errors.blank?
      if transaction
        attr_names = %i[
          type uuid amount status merchant_id
          customer_email customer_phone notification_url created_at
        ]
        attrs = transaction.attributes.slice(*attr_names.map(&:to_s))
        attrs[:parent_transaction_uuid] = transaction.parent_transaction.uuid if transaction.parent_transaction
        response[:transaction] = attrs
      end
      http_status = transaction ? :created : :unprocessable_entity
      respond_to do |format|
        format.json { render json: response, status: http_status }
        format.xml { render xml: response, status: http_status }
      end
    end

    def echo
      respond_to do |format|
        format.json { render json: params, status: :ok }
        format.xml { render xml: params, status: :ok }
      end
    end

    private

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
