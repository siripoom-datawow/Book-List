redis_host = Settings.redis.host.presence || 'localhost'
redis_port = Settings.redis.port.presence || 6379

url =  "redis://#{redis_host}:#{redis_port}"

Sidekiq.configure_server do |config|
  config.redis = { url: $redis.id }
end

Sidekiq.configure_client do |config|
  config.redis = { url: $redis.id }
end

schedule_file = "config/schedule.yml"
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file))
end
