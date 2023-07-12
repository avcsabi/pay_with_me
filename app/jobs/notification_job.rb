# frozen_string_literal: true

# A background job must be enqueued for sending an HTTP POST
# notification to the notification_url as soon as the transactions processed
class NotificationJob < ApplicationJob
  require 'securerandom'
  require 'net/http'

  def perform(*args)
    options = args.last || {}
    transaction_id = options[:transaction_id]
    raise ArgumentError.new('transaction_id is missing') if transaction_id.blank?

    transaction = AuthorizeTransaction.find_by(id: transaction_id)
    raise ArgumentError.new("AuthorizeTransaction with ID #{transaction_id} is missing") unless transaction

    unless transaction.approved? || transaction.declined?
      raise ArgumentError.new("AuthorizeTransaction with ID #{transaction_id} is not approved or declined")
    end

    ntf = Notifier.new(notification_url: transaction.notification_url,
                       unique_id: transaction.uuid,
                       amount: transaction.amount,
                       status: transaction.status)
    ntf.call
  end
end
