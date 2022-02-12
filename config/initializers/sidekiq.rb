schedule_file = "config/schedule.yml"

if File.exist?(schedule_file) && Sidekiq.server?
	Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

sidekiq_config = { url: ENV['REDIS_URL'] }

Sidekiq.configure_server do |config|
	config.redis = sidekiq_config

	config.death_handlers << ->(job, ex) do
		Sentry.capture_exception(ex)
		puts "Uh oh, #{job['class']} #{job["jid"]} just died with error #{ex.message}."
	end
end

Sidekiq.configure_client do |config|
	config.redis = sidekiq_config
end
