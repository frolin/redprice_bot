module Stores
	class Ozon
		def initialize(config:, store:)
			@store = store
			@config = config
			@attributes = config[:attributes]
		end

		def extract_product_data
			result = {}

			page = Browser.new(@store.url).process
			page.manage.timeouts.implicit_wait = 30 # seconds

			price_with_sale = page.find_element(xpath: "//*[@#{@attributes['price_data']}]//div[2]/div")
			min_price = page.find_element(xpath: "//*[@#{@attributes['price_data']}]//div[2]/div/span[1]/span").text


			result[:min_price] = min_price
			result[:all_data] = price_with_sale['innerHTML']
			# result[:name] = name

			result
		end

	end
end