# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorizeTransaction, type: :model do
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_presence_of(:merchant) }

  describe 'total_captured_amount' do
    let(:aut_tr) { FactoryBot.create(:authorize_transaction, amount: 100, status: 'captured') }

    it 'returns the correct total taking into account refunds' do
      FactoryBot.create(:capture_transaction, parent_transaction: aut_tr, merchant: aut_tr.merchant, amount: 50)
      cap_tr2 = FactoryBot.create(:capture_transaction, parent_transaction: aut_tr, merchant: aut_tr.merchant,
                                                        amount: 50, status: 'refunded')
      FactoryBot.create(:refund_transaction, parent_transaction: cap_tr2, merchant: aut_tr.merchant, amount: 20)
      FactoryBot.create(:refund_transaction, parent_transaction: cap_tr2, merchant: aut_tr.merchant, amount: 10)
      expect(aut_tr.total_captured_amount).to eq(50 + 50 - 20 - 10)
    end
  end

  describe 'after_create' do
    it 'enqueues a background job to transition the status' do
      expect { FactoryBot.create(:authorize_transaction) }.to change(Delayed::Job, :count).by(1)
    end
  end

  describe 'before_validation' do
    it 'sets the default status to pending' do
      aut_tr = described_class.new
      expect { aut_tr.valid? }.to change(aut_tr, :status).from(nil).to('pending')
    end

    it 'does not set the default status to pending if it is already set' do
      aut_tr = described_class.new(status: 'error')
      aut_tr.valid?
      expect(aut_tr.status).to eq('error')
    end
  end

  describe 'custom validations' do
    it 'does not allow setting a parent transaction' do
      aut_tr = FactoryBot.build(:authorize_transaction)
      expect do
        aut_tr.parent_transaction = FactoryBot.create(:authorize_transaction, merchant: aut_tr.merchant)
      end.to change(aut_tr, :valid?).from(true).to(false)
    end
  end
end
