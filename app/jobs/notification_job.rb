# frozen_string_literal: true

# A background job must be enqueued for sending an HTTP POST
# notification to the notification_url as soon as the transactions processed
class NotificationJob < ApplicationJob
  def perform(*args)
    options = args.last || {}
    transaction_id = options[:transaction_id].presence
    transaction = transaction_id && AuthorizeTransaction.find_by(id: transaction_id)
    raise ArgumentError, 'invalid transaction_id' unless transaction

    unless transaction.approved? || transaction.declined?
      raise ArgumentError, "AuthorizeTransaction with ID #{transaction_id} is not approved or declined"
    end

    Notifier.new(notification_url: transaction.notification_url,
                 unique_id: transaction.uuid, amount: transaction.amount, status: transaction.status).call
  end
end
