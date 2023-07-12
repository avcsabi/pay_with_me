# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MerchantsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/merchants').to route_to('merchants#index')
    end

    it 'routes to #new' do
      expect(get: '/merchants/new').to route_to('merchants#new')
    end

    it 'routes to #show' do
      expect(get: '/merchants/1').to route_to('merchants#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/merchants/1/edit').to route_to('merchants#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/merchants').to route_to('merchants#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/merchants/1').to route_to('merchants#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/merchants/1').to route_to('merchants#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/merchants/1').to route_to('merchants#destroy', id: '1')
    end
  end
end
