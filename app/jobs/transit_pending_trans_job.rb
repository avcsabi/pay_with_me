# frozen_string_literal: true

# A background job must be enqueued to process the transaction
# (random transition to either approved or declined)
class TransitPendingTransJob < ApplicationJob
  def perform(*args)
    options = args.last || {}
    transaction_id = options[:transaction_id].presence
    transaction = transaction_id && AuthorizeTransaction.find_by(id: transaction_id)
    raise ArgumentError, 'invalid transaction_id' unless transaction

    raise ArgumentError, "AuthorizeTransaction with ID #{transaction_id} is not pending" unless transaction.pending?

    transaction.status = %w[approved declined][rand(2)]
    transaction.save!
    NotificationJob.perform_later(transaction_id: transaction.id)
  end
end
