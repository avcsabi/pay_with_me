# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing a merchant', type: :feature do
  let(:mrc) do
    FactoryBot.create(:merchant, name: 'Great merchant',
                                 description: 'good reviews', email: 'great-merchant@gm.com')
  end

  before do
    login_as FactoryBot.create(:admin)
    visit edit_merchant_path mrc
  end

  describe 'has the existing field values' do
    it 'sets the name' do
      expect(page).to have_field('Name', with: 'Great merchant')
    end

    it 'sets the description' do
      expect(page).to have_field('Description', with: 'good reviews')
    end

    it 'sets the email' do
      expect(page).to have_field('Email', with: 'great-merchant@gm.com')
    end
  end

  it 'saves with valid inputs' do
    {
      'Name' => 'Greater merchant',
      'Description' => 'excellent reviews',
      'Email' => 'gr-m@gm.com',
      'Password' => 'great secret',
      'Password confirmation' => 'great secret'
    }.each_pair { |name, value| fill_in(name, with: value) }
    click_on 'Save'
    expect(page).to have_content('success').and(have_content('Greater merchant'))
                                           .and(have_content('excellent reviews'))
                                           .and(have_content('gr-m@gm.com'))
  end

  it 'shows errors when inputs are not valid' do
    fill_in 'Name', with: ''
    click_on 'Save'
    expect(page).to have_content("Name can't be blank")
  end
end
