require 'rails_helper'

RSpec.describe 'Lists merchants', type: :feature do
  scenario 'for admins' do
    login_as FactoryBot.create(:admin)
    FactoryBot.create :admin, name: 'This admin'
    FactoryBot.create :admin, name: 'That admin'
    FactoryBot.create :merchant, name: 'This merchant'
    FactoryBot.create :merchant, name: 'That merchant'
    visit merchants_path
    expect(page).to have_content('This admin')
    expect(page).to have_content('That admin')
    expect(page).to have_content('This merchant')
    expect(page).to have_content('That merchant')
  end
end
