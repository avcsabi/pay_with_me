# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_presence_of(:merchant) }
  it { is_expected.to belong_to(:merchant) }
  it { is_expected.to belong_to(:parent_transaction).optional }
  it { is_expected.to have_many(:transactions) }
  it { is_expected.to validate_inclusion_of(:status).in_array(Transaction::STATUSES) }

  describe 'generate_uuid' do
    it 'generates an uuid' do
      transaction = described_class.new
      expect { transaction.generate_uuid }.to change(transaction, :uuid).from(nil).to(/^.{36}$/)
    end

    it 'fills in uuid before validation' do
      transaction = described_class.new
      expect { transaction.valid? }.to change(transaction, :uuid).from(nil).to(/^.{36}$/)
    end
  end

  describe 'create_from_params' do
    describe 'providing an invalid transaction type' do
      let(:params) { { type: 'abc', amount: 12 } }
      let(:merchant) { FactoryBot.create :merchant }
      let(:results) { described_class.create_from_params(params, merchant) }

      it 'returns hash with errors' do
        expect(results).to be_a(Hash).and(have_key(:errors))
      end

      it 'does not return a transaction' do
        expect(results).not_to have_key(:transaction)
      end

      it 'returns an error that describes the issue' do
        expect(results[:errors][:base]).to include('Invalid transaction type')
      end
    end

    describe 'providing an invalid parent transaction uuid' do
      let(:params) do
        {
          type: 'CaptureTransaction',
          amount: 12,
          parent_transaction_uuid: 'abc'
        }
      end
      let(:merchant) { FactoryBot.create(:merchant) }
      let(:results) { described_class.create_from_params(params, merchant) }

      it 'saves it with error status' do
        expect { results }.to change(CaptureTransaction, :count).by(1)
      end

      it 'will return the transaction as a hash' do
        expect(results[:transaction]).to be_a(Hash)
      end

      it 'will return the transaction type as a CaptureTransaction' do
        expect(results[:transaction]['type']).to eq('CaptureTransaction')
      end

      it "will return the error 'not found' in [:errors]['parent_transaction']" do
        expect(results[:errors]['parent_transaction']).to include('not found')
      end

      it 'will return the transaction status as error' do
        expect(results[:transaction]['status']).to eq('error')
      end
    end

    describe 'providing attributes that lead to a validation error' do
      let(:merchant) { FactoryBot.create :merchant }
      let(:aut_tr) { FactoryBot.create(:authorize_transaction, merchant:, status: 'approved') }
      let(:params) do
        {
          type: 'CaptureTransaction',
          amount: -1, # otherwise valid params
          parent_transaction_uuid: aut_tr.uuid,
          customer_email: Faker::Internet.email
        }
      end
      let(:results) { described_class.create_from_params(params, merchant) }

      it 'saves it with error status' do
        expect { results }.to change(CaptureTransaction, :count).by(1)
      end

      it 'will return the transaction type as a CaptureTransaction' do
        expect(results[:transaction]['type']).to eq('CaptureTransaction')
      end

      it "will return the error 'must be greater than 0' in [:errors]['amount']" do
        expect(results[:errors]['amount']).to include('must be greater than 0')
      end

      it 'will return the transaction status as error' do
        expect(results[:transaction]['status']).to eq('error')
      end
    end
  end
end
