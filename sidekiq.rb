redis_host = Settings.redis.host.presence || 'localhost'
redis_port = Settings.redis.port.presence || 6379

url =  "redis://#{redis_host}:#{redis_port}"

Sidekiq.configure_server do |config|
  config.redis = { url: $redis.id }
end

Sidekiq.configure_client do |config|
  config.redis = { url: $redis.id }
end
