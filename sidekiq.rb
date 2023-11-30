# frozen_string_literal: true

Settings.redis.host.presence || 'localhost'
Settings.redis.port.presence || 6379

Sidekiq.configure_server do |config|
  config.redis = { url: $redis.id }
end

Sidekiq.configure_client do |config|
  config.redis = { url: $redis.id }
end
