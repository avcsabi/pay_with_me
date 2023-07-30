# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::MerchantsController, type: :routing do
  describe 'routing' do
    it 'routes to #jwt_token' do
      expect(post: 'api/get_jwt_token').to route_to('api/merchants#jwt_token', format: :json)
    end
  end
end
