require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  telegram_webhook TelegramWebhooksController

  mount Sidekiq::Web => '/sidekiq'
end
