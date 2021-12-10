class AddBasicProduct
	def self.call(from, url, sitename: 'yandex')
		Browsers::JsBrowser.new(sitename: sitename, url: url).process
	end
end