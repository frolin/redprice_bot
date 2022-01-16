require "selenium-webdriver"

module Store::Type
	class YandexMarket < ActiveInteraction::Base

		object :page, class: Selenium::WebDriver::Chrome::Driver
		hash :attributes, strip: false
		object :user, default: false

		def execute
			product = []


			wait = Selenium::WebDriver::Wait.new(:timeout => 30) # seconds
			articles = wait.until { page.find_elements(css: "article") }

			articles.each do |article|
				result = {}

				attributes.each do |name, attr|
					result[name] = wait.until { page.find_element(css: attr).text }
				end
				product << result
			end

			# offers = wait.until { page.find_elements(xpath: "//*[@#{attributes['row']}]") }
			# prices = wait.until { page.find_elements(xpath: "//*[@#{attributes['price_data']}]") }

			# @todo fix blank, but why?
			min_price = prices.map { |offer| offer.text }.reject(&:empty?).sort.first
			all_data = offers.map { |offer| offer.text.split("\n") }

			errors.add(:base, 'error no price or data found') if min_price.blank?
			errors.add(:base, 'all data not found') if all_data.blank?


			{ 'all_data' => all_data, 'price' => min_price }
		end

		private

		def find_element_type(type, value)
			type = type.split('_').last

			case type
			when 'data'
				element = @wait.until { page.find_element(xpath: "//*[@#{value}]").attribute("innerHTML") }
				element = ActionView::Base.full_sanitizer.sanitize(element)
			else
				element = @wait.until { page.find_element(css: value) }
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