class ParseStoresWorker
	include Sidekiq::Worker

	def perform(username)
		::Parsing::Stores.run(username: username)
	end

end