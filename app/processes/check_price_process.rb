class CheckPriceProcess

	def self.check(sitename, search_text)
		# job_params ={[sitename, search_text]

		ParserWorker.perform_async(sitename, search_text)
	end

end