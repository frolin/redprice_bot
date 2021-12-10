class AddBasicProduct
	def self.call(from, url, sitename: 'yandex_market')
		Browsers::BaseBrowser.new(sitename: sitename, url: url).find
	end
end