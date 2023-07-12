require 'rails_helper'

RSpec.describe 'Display transactions', type: :feature do
  before(:example) do
    @merchant = FactoryBot.create(:merchant)
    FactoryBot.create :authorize_transaction, customer_email: 'customer1@email.com'
    FactoryBot.create :authorize_transaction, customer_email: 'customer2@email.com'
    FactoryBot.create :authorize_transaction, customer_email: 'customer3@email.com'
    FactoryBot.create :authorize_transaction, customer_email: 'customer4@email.com', merchant: @merchant
    FactoryBot.create :authorize_transaction, customer_email: 'customer5@email.com', merchant: @merchant
  end

  scenario 'admins see all transactions' do
    login_as FactoryBot.create(:admin)
    visit transactions_path
    %w[customer1@email.com customer2@email.com customer3@email.com customer4@email.com customer5@email.com].each do |e|
      expect(page).to have_content(e)
    end
  end

  scenario 'merchants see their own transactions only' do
    login_as @merchant
    visit transactions_path
    %w[customer1@email.com customer2@email.com customer3@email.com].each do |e|
      expect(page).to have_no_content(e)
    end
    %w[customer4@email.com customer5@email.com].each do |e|
      expect(page).to have_content(e)
    end
  end
end
