# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/transactions', type: :request do
  before do
    login_as FactoryBot.create(:admin)
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      FactoryBot.create :authorize_transaction
      get transactions_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      transaction = FactoryBot.create(:authorize_transaction)
      get transaction_url(transaction)
      expect(response).to be_successful
    end
  end
end
