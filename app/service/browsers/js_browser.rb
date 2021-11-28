require "selenium-webdriver"

module Browsers
	class JsBrowser < BaseBrowser
		def initialize(sitename, search_text)
			super(sitename, search_text)
			@attributes = @config[:attributes]
			@wait = Selenium::WebDriver::Wait.new(:timeout => 10)
		end

		def found
			products_list
		end

		def browser
			@browser ||= Selenium::WebDriver.for :chrome, options: options
		end

		def options
			options = Selenium::WebDriver::Chrome::Options.new
			# options.add_argument('--headless')
			options.add_argument('--enable-javascript')
			options.add_argument('--no-sandbox')
			options.add_argument('--ignore-certificate-errors')
			options.add_argument('--allow-insecure-localhost')
			options.add_argument("--window-size=1920,1080")
			options.add_argument("--start-maximized")

			options
		end

		def search
			# search_bar = wait.until { browser.find_element(@site_config[:search_selector].keys.first.to_sym, @site_config[:search_selector].values.first) }

			# search_bar.send_keys @search_text
			# search_bar.submit
		end

		def get_list

		end

		def products_list
			browser.get @search_query

			products_list = @wait.until { browser.find_elements(css: @config[:product_list_css]) }

			products_list.each do |product|
				result = {}

				@attributes.each do |type, value|
					begin
						element = product.find_element(css: value)
						result["#{type}".to_sym] = attribute_type(type, element)

					rescue StandardError => e
						Rails.logger.error("#{e}, element not found")
						nil
					end
				end

				results << result
			end

			browser.quit
			Rails.logger.debug('quit browser')
		end

		def attribute_type(type, element)
			type.split('-').include?('link') ? element.attribute(:href) : element.text
		rescue
			''
		end

	end
end
