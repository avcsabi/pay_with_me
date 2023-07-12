require 'rails_helper'

RSpec.describe 'Editing a merchant', type: :feature do
  scenario 'works with valid inputs' do
    login_as FactoryBot.create(:admin)
    m = FactoryBot.create(:merchant, name: 'Great merchant',
                                 description: 'good reviews', email: 'great-merchant@gm.com')
    visit edit_merchant_path(m)
    sleep(2)
    expect(page).to have_field('Name', with: 'Great merchant')
    expect(page).to have_field('Description', with: 'good reviews')
    expect(page).to have_field('Email', with: 'great-merchant@gm.com')
    fill_in 'Name', with: 'Greater merchant'
    fill_in 'Description', with: 'excellent reviews'
    fill_in 'Email', with: 'greater-merchant@gm.com'
    fill_in 'Password', with: 'great secret'
    fill_in 'Password confirmation', with: 'great secret'
    click_on 'Save'
    expect(page).to have_content('success')
    m.reload
    expect(m.name).to eq('Greater merchant')
    expect(m.description).to eq('excellent reviews')
    expect(m.email).to eq('greater-merchant@gm.com')
  end

  scenario 'shows errors when inputs are not valid' do
    login_as FactoryBot.create(:admin)
    m = FactoryBot.create(:merchant)
    visit edit_merchant_path(m)
    fill_in 'Name', with: ''
    click_on 'Save'
    expect(page).to have_content("Name can't be blank")
  end
end
