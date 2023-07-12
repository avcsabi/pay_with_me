# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/merchants', type: :request do
  before(:each) do
    login_as FactoryBot.create(:admin)
  end

  # This should return the minimal set of attributes required to create a valid
  # Merchant. As you add validations to Merchant, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      name: 'Active Merchant',
      description: 'Active Merchant description',
      email: Faker::Internet.email,
      admin: false,
      password: 'big secret',
      password_confirmation: 'big secret'
    }
  }

  let(:invalid_attributes) {
    {
      name: nil
    }
  }

  describe 'GET /index' do
    it 'renders a successful response' do
      Merchant.create! valid_attributes
      get merchants_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      merchant = Merchant.create! valid_attributes
      get merchant_url(merchant)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_merchant_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      merchant = Merchant.create! valid_attributes
      get edit_merchant_url(merchant)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Merchant' do
        expect {
          post merchants_url, params: { merchant: valid_attributes }
        }.to change(Merchant, :count).by(1)
      end

      it 'redirects to the created merchant' do
        post merchants_url, params: { merchant: valid_attributes }
        expect(response).to redirect_to(merchant_url(Merchant.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Merchant' do
        expect {
          post merchants_url, params: { merchant: invalid_attributes }
        }.to change(Merchant, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post merchants_url, params: { merchant: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) {
        {
          name: 'Active Merchant Updated',
          description: 'Active Merchant description Updated',
          email: Faker::Internet.email,
          admin: false,
          password: 'big secret',
          password_confirmation: 'big secret'
        }
      }

      it 'updates the requested merchant' do
        merchant = Merchant.create! valid_attributes
        patch merchant_url(merchant), params: { merchant: new_attributes }
        merchant.reload
        expect(merchant.name).to eq('Active Merchant Updated')
        expect(merchant.description).to eq('Active Merchant description Updated')
      end

      it 'redirects to the merchant' do
        merchant = Merchant.create! valid_attributes
        patch merchant_url(merchant), params: { merchant: new_attributes }
        merchant.reload
        expect(response).to redirect_to(merchant_url(merchant))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        merchant = Merchant.create! valid_attributes
        patch merchant_url(merchant), params: { merchant: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested merchant' do
      merchant = Merchant.create! valid_attributes
      expect { delete merchant_url(merchant) }.to change(Merchant, :count).by(-1)
    end

    it 'redirects to the merchants list' do
      merchant = Merchant.create! valid_attributes
      delete merchant_url(merchant)
      expect(response).to redirect_to(merchants_url)
    end

    it 'does not allow deleting of the merchant if it has one ore more transactions' do
      merchant = FactoryBot.create(:authorize_transaction).merchant
      expect { delete merchant_url(merchant) }.to change(Merchant, :count).by(0)
    end
  end
end
