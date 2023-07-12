# frozen_string_literal: true

# A background job must be enqueued to process the transaction
# (random transition to either approved or declined)
class TransitPendingTransJob < ApplicationJob
  def perform(*args)
    options = args.last || {}
    transaction_id = options[:transaction_id]
    raise ArgumentError.new('transaction_id is missing') if transaction_id.blank?

    transaction = AuthorizeTransaction.find_by(id: transaction_id)
    raise ArgumentError.new("AuthorizeTransaction with ID #{transaction_id} is missing") unless transaction

    raise ArgumentError.new("AuthorizeTransaction with ID #{transaction_id} is not pending") unless transaction.pending?

    transaction.status = %w[approved declined][rand(2)]
    transaction.save!
    NotificationJob.perform_later(transaction_id: transaction.id)
  end
end
