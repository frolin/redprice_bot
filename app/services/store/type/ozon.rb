module Store::Type
	class Ozon < ActiveInteraction::Base

		object :page, class: Selenium::WebDriver::Chrome::Driver
		hash :attributes, strip: false
		object :user, default: false

		def execute

			wait = Selenium::WebDriver::Wait.new(:timeout => 30) # seconds

			price_with_sale = wait.until { page.find_element(xpath: "//*[@#{attributes['price_data']}]//div[2]/div") }
			sale_price = wait.until { price_with_sale.find_element(css: 'span:nth-child(1)').text.strip }
			old_price = wait.until { price_with_sale.find_element(css: 'span:nth-child(2)').text.strip }

			# min_price = page.find_element(xpath: "//*[@#{attributes['price_data']}]//div[2]/div/span[1]/span").text
			# Struct.new(:min_price, :all_data, :errors).new(min_price, price_with_sale['innerHTML'], errors)
			{ raw_data: price_with_sale.attribute('innerHTML'), sale_price: sale_price, old_price: old_price, price: sale_price }
		end
	end
end
