bot: rake telegram:bot:set_webhook RAILS_ENV=production
worker: bundle exec sidekiq -e production -C config/sidekiq.yml
release: bundle exec rake db:migrate