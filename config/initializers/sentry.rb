Sentry.init do |config|
  config.dsn = 'http://fad85e5a6b234a5d884eb6f0adfb9989@0.0.0.0:9000/1'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set tracesSampleRate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end