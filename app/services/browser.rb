require "selenium-webdriver"

class Browser
	def initialize(url)
		@url = url
	end

	def process
		browser.get @url

		browser
	end

	def browser
		options = %w[disable-gpu no-sandbox window-size=412,915 enable-javascript start-maximized]

		@browser ||= Selenium::WebDriver.for :chrome, capabilities:
			[Selenium::WebDriver::Chrome::Options.new(args: options)]
	end
end