# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::TransactionsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: 'api/transactions/create').to route_to('api/transactions#create', format: :json)
    end
  end
end
