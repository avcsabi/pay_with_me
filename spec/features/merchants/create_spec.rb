# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating a merchant', type: :feature do
  before do
    login_as FactoryBot.create(:admin)
    visit new_merchant_path
  end

  it 'works with valid inputs' do
    fields = {
      'Name' => 'Test Merchant 1',
      'Description' => 'Test Merchant 1 Description',
      'Email' => 'test-merchant-1@paywithme.com',
      'Password' => '654321',
      'Password confirmation' => '654321'
    }
    fields.each_pair { |name, value| fill_in(name, with: value) }
    click_on 'Save'
    visit merchants_path
    expect(page).to have_content('Test Merchant 1')
  end

  it 'shows errors when inputs are not valid' do
    fill_in 'Name', with: ''
    click_on 'Save'
    expect(page).to have_content("Name can't be blank")
  end
end
