require "openssl"

redis_url = ENV["REDIS_URL"]
redis_config = redis_url.present? ? { url: redis_url } : {}

if redis_url&.start_with?("rediss://")
  redis_config[:ssl_params] = { verify_mode: OpenSSL::SSL::VERIFY_NONE }
end

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end