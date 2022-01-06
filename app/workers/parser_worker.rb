class ParserWorker
  include Sidekiq::Worker

  def perform(user_id)
    Rails.logger.info("Start worker for parsing")
    ParseStores.new(user_id)
  end
end
