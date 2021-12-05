class ParserWorker
  include Sidekiq::Worker

  def perform(sitename, search_text)
    Rails.logger.info("Start worker for parse")
    Browsers::BaseBrowser.new(sitename, search_text).find
  end
end
