require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it {is_expected.to validate_presence_of(:name)}
  it {is_expected.to validate_presence_of(:status)}
  it {is_expected.to validate_presence_of(:email)}
  it {is_expected.to validate_inclusion_of(:status).in_array(%w[active inactive])}
  it { should have_many(:transactions) }

  describe 'admins' do
    it 'includes users with admin flag and excludes users without admin flag' do
      admin = FactoryBot.create(:admin)
      merchant = FactoryBot.create(:merchant)
      expect(Merchant.admins).to include(admin)
      expect(Merchant.admins).not_to include(merchant)
    end
  end

  describe 'active' do
    it 'includes active merchants' do
      active_merchant = FactoryBot.create(:merchant)
      expect(Merchant.active).to include(active_merchant)
    end

    it 'excludes inactive merchants' do
      inactive_merchant = FactoryBot.create(:merchant_inactive)
      expect(Merchant.active).not_to include(inactive_merchant)
    end
  end

  describe '.inactive' do
    it 'includes inactive merchants' do
      inactive_merchant = FactoryBot.create(:merchant_inactive)
      expect(Merchant.inactive).to include(inactive_merchant)
    end

    it 'excludes active merchants' do
      active_merchant = FactoryBot.create(:merchant)
      expect(Merchant.inactive).not_to include(active_merchant)
    end
  end

  describe 'is_active?' do
    it 'returns true if status is active' do
      active_merchant = FactoryBot.create(:merchant)
      expect(active_merchant.is_active?).to eq(true)
    end

    it 'returns false if status is not active' do
      inactive_merchant = FactoryBot.create(:merchant_inactive)
      expect(inactive_merchant.is_active?).to eq(false)
    end
  end

  describe 'name_and_email' do
    it 'concatenates name and email' do
      merchant = FactoryBot.create(:merchant)
      expect(merchant.name_and_email).to include(merchant.name)
      expect(merchant.name_and_email).to include(merchant.email)
    end
  end

  describe 'active_for_authentication?' do
    it 'returns false if merchant is not active and true if is active' do
      merchant_inactive = FactoryBot.create(:merchant_inactive)
      merchant_active = FactoryBot.create(:merchant)
      expect(merchant_inactive.active_for_authentication?).to eq(false)
      expect(merchant_active.active_for_authentication?).to eq(true)
    end
  end

end
