REDIS_OPTS = {
  url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"),
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
}
$redis = Redis.new(**REDIS_OPTS)
