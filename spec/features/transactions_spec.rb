# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Display transactions', type: :feature do
  let(:mrc) { FactoryBot.create(:merchant) }

  before do
    FactoryBot.create :authorize_transaction, customer_email: 'customer1@email.com'
    FactoryBot.create :authorize_transaction, customer_email: 'customer2@email.com'
    FactoryBot.create :authorize_transaction, customer_email: 'customer3@email.com'
    FactoryBot.create :authorize_transaction, customer_email: 'customer4@email.com', merchant: mrc
    FactoryBot.create :authorize_transaction, customer_email: 'customer5@email.com', merchant: mrc
  end

  describe 'when an admin is logged in' do
    before do
      login_as FactoryBot.create(:admin)
      visit transactions_path
    end

    it 'shows transactions of all merchants' do
      %w[customer1@email.com customer2@email.com customer3@email.com
         customer4@email.com customer5@email.com].each do |e|
        expect(page).to have_content(e)
      end
    end
  end

  describe 'when a merchant is logged in' do
    before do
      login_as mrc
      visit transactions_path
    end

    it 'shows their own transactions' do
      %w[customer4@email.com customer5@email.com].each do |e|
        expect(page).to have_content(e)
      end
    end

    it "does not show other merchant's transactions" do
      %w[customer1@email.com customer2@email.com customer3@email.com].each do |e|
        expect(page).to have_no_content(e)
      end
    end
  end
end
