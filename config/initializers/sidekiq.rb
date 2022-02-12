schedule_file = "config/schedule.yml"

if File.exist?(schedule_file) && Sidekiq.server?
	Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

Sidekiq.configure_client do |config|
  config.redis = {
    host: ENV['REDIS_HOST'],
    port: ENV['REDIS_PORT'] || '6379'
  }
end

Sidekiq.configure_server do |config|

  config.redis = {
    host: ENV['REDIS_HOST'],
    port: ENV['REDIS_PORT'] || '6379'
  }

	config.death_handlers << ->(job, ex) do
		Sentry.capture_exception(ex)
		puts "Uh oh, #{job['class']} #{job["jid"]} just died with error #{ex.message}."
	end

end
