require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it {is_expected.to validate_presence_of(:type)}
  it {is_expected.to validate_presence_of(:merchant)}
  it { should belong_to(:merchant) }
  it { should belong_to(:parent_transaction).optional }
  it { should have_many(:transactions) }
  it {is_expected.to validate_inclusion_of(:status).in_array(Transaction::STATUSES)}

  describe 'generate_uuid' do
    it 'generates an uuid' do
      transaction = Transaction.new
      expect(transaction.uuid).to eq(nil)
      transaction.generate_uuid
      expect(transaction.uuid.length).to eq(SecureRandom.uuid.length)
    end

    it 'should fill in uuid before validation' do
      transaction = Transaction.new
      expect(transaction.uuid).to eq(nil)
      transaction.valid?
      expect(transaction.uuid).not_to eq(nil)
    end
  end

  describe 'create_from_params' do
    it 'handles an invalid transaction type' do
      params = {
        type: 'abc',
        amount: 12
      }
      merchant = FactoryBot.create :merchant
      transaction, errors = Transaction.create_from_params(params, merchant)
      expect(transaction).to eq(nil)
      expect(errors.values).to include('Invalid transaction type')
    end

    it 'handles an invalid parent transaction uuid but saves it with error status' do
      params = {
        type: 'CaptureTransaction',
        amount: 12,
        parent_transaction_uuid: 'abc'
      }
      merchant = FactoryBot.create :merchant
      transaction, errors = Transaction.create_from_params(params, merchant)
      expect(transaction.class.name).to eq('CaptureTransaction')
      expect(errors.values).to include('Parent transaction not found')
      expect(transaction.id).to_not eq(nil)
      expect(transaction.status).to eq('error')
    end

    it 'handles an validation errors but saves it with error status and returns the errors' do
      merchant = FactoryBot.create :merchant
      aut_tr = FactoryBot.create(:authorize_transaction, merchant: merchant, status: 'approved')
      # otherwise valid params
      params = {
        type: 'CaptureTransaction',
        amount: -1,
        parent_transaction_uuid: aut_tr.uuid,
        customer_email: Faker::Internet.email
      }
      transaction, errors = Transaction.create_from_params(params, merchant)
      expect(transaction.class.name).to eq('CaptureTransaction')
      expect(errors[:amount]).to include('must be greater than 0')
      expect(transaction.id).to_not eq(nil)
      expect(transaction.status).to eq('error')
    end

  end
end