# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_inclusion_of(:status).in_array(%w[active inactive]) }
  it { is_expected.to have_many(:transactions) }

  describe 'admins' do
    let(:admin) { FactoryBot.create(:admin) }
    let(:merchant) { FactoryBot.create(:merchant) }

    it 'includes users with admin flag' do
      expect(described_class.admins).to include(admin)
    end

    it 'and excludes users without admin flag' do
      expect(described_class.admins).not_to include(merchant)
    end
  end

  describe 'active' do
    it 'includes active merchants' do
      active_merchant = FactoryBot.create(:merchant)
      expect(described_class.active).to include(active_merchant)
    end

    it 'excludes inactive merchants' do
      inactive_merchant = FactoryBot.create(:merchant_inactive)
      expect(described_class.active).not_to include(inactive_merchant)
    end
  end

  describe '.inactive' do
    it 'includes inactive merchants' do
      inactive_merchant = FactoryBot.create(:merchant_inactive)
      expect(described_class.inactive).to include(inactive_merchant)
    end

    it 'excludes active merchants' do
      active_merchant = FactoryBot.create(:merchant)
      expect(described_class.inactive).not_to include(active_merchant)
    end
  end

  describe 'active?' do
    it 'returns true if status is active' do
      active_merchant = FactoryBot.create(:merchant)
      expect(active_merchant.active?).to eq(true)
    end

    it 'returns false if status is not active' do
      inactive_merchant = FactoryBot.create(:merchant_inactive)
      expect(inactive_merchant.active?).to eq(false)
    end
  end

  describe 'name_and_email' do
    it 'concatenates name and email' do
      merchant = FactoryBot.create(:merchant)
      expect(merchant.name_and_email).to include(merchant.name).and(include(merchant.email))
    end
  end

  describe 'active_for_authentication?' do
    let(:merchant_inactive) { FactoryBot.create(:merchant_inactive) }
    let(:merchant_active) { FactoryBot.create(:merchant) }

    it 'returns false if merchant is not active' do
      expect(merchant_inactive.active_for_authentication?).to eq(false)
    end

    it 'returns true if merchant is active' do
      expect(merchant_active.active_for_authentication?).to eq(true)
    end
  end
end
