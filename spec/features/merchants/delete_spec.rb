# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deleting a merchant', type: :feature do
  before do
    login_as FactoryBot.create(:admin)
  end

  it 'works when merchant has no transactions' do
    mrc_no_tr = FactoryBot.create(:merchant, name: 'Merchant with no tr')
    visit merchants_path
    page.accept_alert('Are you sure?') { click_link 'Delete', href: merchant_path(mrc_no_tr) }
    expect(page).to have_content('Merchant was successfully deleted')
  end

  it 'shows error when merchant has one ore more transactions' do
    mrc_tr = FactoryBot.create(:authorize_transaction).merchant
    visit merchants_path
    page.accept_alert('Are you sure?') { click_link 'Delete', href: merchant_path(mrc_tr) }
    expect(page).to have_content('Merchant cannot be deleted because it has transactions')
  end
end
