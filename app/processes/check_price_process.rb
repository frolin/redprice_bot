class CheckPriceProcess

	def self.check(sitename, search_text)
		Browsers::BaseBrowser.new(sitename, search_text).find
	end

end