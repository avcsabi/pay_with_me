require 'rails_helper'

RSpec.describe 'Deleting a merchant', type: :feature do
  scenario 'works when merchant has no transactions' do
    login_as FactoryBot.create(:admin)
    m = FactoryBot.create(:merchant, name: 'Merchant to delete')
    visit merchants_path
    sleep(2)
    expect(page).to have_content('Merchant to delete')
    page.accept_alert 'Are you sure?' do
      click_link 'Delete', href: merchant_path(m)
    end
    expect(page).to have_content('Merchant was successfully deleted')
  end

  scenario 'shows error when merchant has one ore more transactions' do
    login_as FactoryBot.create(:admin)
    tr = FactoryBot.create(:authorize_transaction)
    visit merchants_path
    page.accept_alert 'Are you sure?' do
      click_link 'Delete', href: merchant_path(tr.merchant)
    end
    expect(page).to have_content('Merchant cannot be deleted because it has transactions')
  end
end
