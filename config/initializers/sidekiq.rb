# frozen_string_literal: true

Settings.redis.host.presence || 'localhost'
Settings.redis.port.presence || 6379

Sidekiq.configure_server do |config|
  config.redis = { url: $redis.id }
end

Sidekiq.configure_client do |config|
  config.redis = { url: $redis.id }
end

schedule_file = 'config/schedule.yml'
Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file)) if File.exist?(schedule_file) && Sidekiq.server?
