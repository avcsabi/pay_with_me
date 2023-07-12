# frozen_string_literal: true

# Encode and decode a payload using JWT
class JsonWebTokenService
  def self.encode(payload, expires: 24.hours.from_now)
    payload[:exp] = expires.to_i
    JWT.encode payload, secret_key_base, 'HS256'
  end

  def self.decode(token)
    JWT.decode(token, secret_key_base, algorithm: 'HS256').first
  end

  def self.secret_key_base
    Rails.application.secrets.secret_key_base || Rails.application.credentials.secret_key_base
  end
end
