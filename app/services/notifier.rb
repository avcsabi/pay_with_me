# frozen_string_literal: true

# sends an HTTP POST notification to the notification_url
class Notifier < ApplicationService
  require 'securerandom'
  require 'net/http'
  def initialize(notification_url:, unique_id:, amount:, status:)
    @notification_url = notification_url
    @unique_id = unique_id # OR if some other uuid needed then: SecureRandom.uuid
    @amount = amount
    @status = status
    super()
  end

  def call
    uri = URI(@notification_url)
    params = { unique_id: @unique_id, amount: @amount, status: @status }
    encoded_form = URI.encode_www_form(params)
    header = { 'content_type' => 'application/x-www-form-urlencoded' }
    res = Net::HTTP.post(uri, encoded_form, header)
    raise "Error sending notification (status: #{res.class.name} code: #{res.code})" unless res.is_a?(Net::HTTPSuccess)

    # Debug: puts "Notification response for uuid #{@unique_id}:\n#{res.body}"
  end
end
