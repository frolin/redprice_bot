require "selenium-webdriver"

module Stores
	class YandexMarket < ParseStore
		def initialize(config:, store:)
			@config = config
			@store = store
			@attributes = config[:attributes]
			@wait = Selenium::WebDriver::Wait.new(:timeout => 30)
		end

		def extract_product_data
			result = {}

			page = Browser.new(@store.url).process
			page.manage.timeouts.implicit_wait = 30 # seconds

			offers = page.find_elements(xpath: "//*[@#{@attributes['row']}]")

			prices = page.find_elements(xpath: "//*[@#{@attributes['price_data']}]")

			# @todo fix blank, but why?
			min_price = prices.map { |offer| offer.text }.reject(&:empty?).sort.first
			all_data = offers.map {|offer| offer.text.split("\n")  }

			result[:min_price] = min_price
			result[:all_data] = all_data
			# result[:name] = name

			result
		end

		def find_element_type(type, value)
			type = type.split('_').last

			case type
			when 'data'

				element = @wait.until { @page.find_element(xpath: "//*[@#{value}]").attribute("innerHTML") }
				element = ActionView::Base.full_sanitizer.sanitize(element)
			else
				element = @wait.until { @page.find_element(css: value) }
			end

			element
		end

		def attribute_type(type, element)
			type = type.split('_').last

			case type
			when 'link' then
				element.attribute(:href)
			when 'css' then
				element.text
			else
				element
			end

		rescue
			nil
		end

	end
end