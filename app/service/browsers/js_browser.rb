require "selenium-webdriver"

module Browsers
	class JsBrowser < BaseBrowser
		def initialize(sitename:, url:, search_text: nil)
			super(sitename: sitename, url: url)
			@wait = Selenium::WebDriver::Wait.new(:timeout => 10)
		end

		def process
			browser.get @search_query

			# binding.pry
			# razcapcha if capcha?
			# extract_products_list_data(products_list)

			extract_product_data
			close_browser

			results
		end

		def process_capcha
			checkbox if capcha.present?
			capcha_picture_url if capcha_picture.present?
		end

		def checkbox
			checkbox_css = '.CheckboxCaptcha-Checkbox'
			checkbox_el = browser.find_element(css: checkbox_css)

			browser.execute_script('document.write("<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"><\/script>");')
			browser.execute_script("Jquery$('#{checkbox_css}').setAttribute('aria-checked','true');")
			sleep 1
			browser.find_element(css: '.CheckboxCaptcha-Button').click
		end

		def capcha?
			browser.find_element(css: '.CheckboxCaptcha-Anchor')
		end

		def capcha_picture
			browser.find_element(css: '.AdvancedCaptcha-Image')
		end

		def capcha_picture_url
			@capcha_picture ||= @wait.until { browser.find_element(css: '.AdvancedCaptcha-Image').attribute('src') } rescue nil
		end

		def browser
			options = %w[disable-gpu no-sandbox window-size=412,915 enable-javascript start-maximized]

			@browser ||= Selenium::WebDriver.for :chrome, capabilities:
				[Selenium::WebDriver::Chrome::Options.new(args: options)]
		end

		def extract_products
			products_list = @wait.until { browser.find_elements(css: config[:product_list_css]) }
			extract_products_list_data(products_list)
		end

		def extract_product_data
			result = {}

			@attributes.each do |type, value|
				begin
					element = browser.find_element(css: value)
					result["#{type}".to_sym] = attribute_type(type, element)
				rescue StandardError => e
					Rails.logger.error("#{e}, element not found")
					nil
				end
			end
		end

		def extract_products_list_data(products_list)
			products_list.each do |product|
				result = {}

				@attributes.each do |type, value|
					begin
						binding.pry
						element = product.find_element(css: value)
						result["#{type}".to_sym] = attribute_type(type, element)

					rescue StandardError => e
						Rails.logger.error("#{e}, element not found")
						nil
					end
				end

				results << result
			end

			results
		end

		def selenium_capabilities_chrome
			Selenium::WebDriver::Remote::Capabilities.chrome
		end

		def search
			# search_bar = wait.until { browser.find_element(@site_config[:search_selector].keys.first.to_sym, @site_config[:search_selector].values.first) }

			# search_bar.send_keys @search_text
			# search_bar.submit
		end

		def attribute_type(type, element)
			type.split('-').include?('link') ? element.attribute(:href) : element.text
		rescue
			nil
		end

		def close_browser
			browser.quit
			Rails.logger.debug('quit browser')
		end

	end
end
