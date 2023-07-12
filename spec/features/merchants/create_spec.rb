require 'rails_helper'

RSpec.describe 'Creating a merchant', type: :feature do
  scenario 'works with valid inputs' do
    login_as FactoryBot.create(:admin)
    visit new_merchant_path
    fill_in 'Name', with: 'Test Merchant 1'
    fill_in 'Description', with: 'Test Merchant 1 Description'
    fill_in 'Email', with: 'test-merchant-1@paywithme.com'
    fill_in 'Password', with: '654321'
    fill_in 'Password confirmation', with: '654321'
    click_on 'Save'
    visit merchants_path
    expect(page).to have_content('Test Merchant 1')
  end

  scenario 'shows errors when inputs are not valid' do
    login_as FactoryBot.create(:admin)
    visit new_merchant_path
    fill_in 'Name', with: ''
    click_on 'Save'
    expect(page).to have_content("Name can't be blank")
  end
end
