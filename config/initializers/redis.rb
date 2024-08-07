# frozen_string_literal: true

require 'redis'

$redis = Redis.new(
  host: Settings.redis.host,
  port: Settings.redis.port,
  db: Settings.redis.db
)
