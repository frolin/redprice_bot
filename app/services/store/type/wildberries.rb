module Store::Type
	class Wildberries < ActiveInteraction::Base

		object :page, class: Selenium::WebDriver::Chrome::Driver
		hash :attributes, strip: false
		object :user, default: false

		def execute
			wait = Selenium::WebDriver::Wait.new(timeout: 30, interval: 5, message: 'Timed out after 30 sec', ignore: Selenium::WebDriver::Error::NoSuchElementError)
			result = {}

			attributes.each do |name, attr|
				result[name] = wait.until { page.find_element(css: attr).text }
			end

			result.merge('price' => result['final_price'])
		end

	end
end