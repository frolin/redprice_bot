class ParseWorker
	include Sidekiq::Worker
	sidekiq_options queue: :default
  sidekiq_options retry: 5

	ElementNotFound = Class.new(StandardError)
	# ElementNotFoundEvenAfterRetry = Class.new(StandardError)

	sidekiq_retries_exhausted do |msg, exception|
		# example with using Rails' logger
		Rails.logger.warn("Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}", error: exception)
	end

	def perform(store_id)
		begin
			::Store::Parse.run(store_id: store_id)
		rescue ElementNotFound

		end
	end
end