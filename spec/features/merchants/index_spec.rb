# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Listing merchants', type: :feature do
  before do
    FactoryBot.create :admin, name: 'This admin'
    FactoryBot.create :admin, name: 'That admin'
    FactoryBot.create :merchant, name: 'This merchant'
    FactoryBot.create :merchant, name: 'That merchant'
  end

  describe 'when an admin is logged in' do
    before do
      login_as FactoryBot.create(:admin)
      visit merchants_path
    end

    it 'shows all other admins' do
      expect(page).to have_content('This admin').and(have_content('That admin'))
    end

    it 'shows all merchants' do
      expect(page).to have_content('This merchant').and(have_content('That merchant'))
    end
  end

  describe 'when a merchant is logged in' do
    let(:merchant) { FactoryBot.create(:merchant) }

    before do
      login_as merchant
      visit merchants_path
    end

    it 'does not shows admins' do
      expect(page).not_to have_content('This admin')
    end

    it 'does not show other merchants' do
      expect(page).not_to have_content('This merchant')
    end

    it 'shows itself' do
      expect(page).to have_content(merchant.name)
    end
  end
end
