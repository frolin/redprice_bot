require "selenium-webdriver"
module Browsers
	class BaseBrowser
		CONFIG_PATH = "config/sites_config.yml"

		attr_reader :results

		def initialize(sitename, search_text)
			@search_text = search_text
			@sitename = sitename
			@site_config = config[sitename]
			@browser_type = config[sitename][:browser_type]
			@search_url = config[sitename][:q]
			@search_query = @search_url + search_text
			@url = config[sitename][:url]
			@attributes = config[sitename][:attributes]
			@config = config[sitename]

			@results = []
		end

		def config
			@config ||= HashWithIndifferentAccess.new(YAML.load_file(CONFIG_PATH))
		end

		def browser_klass
			"Browsers::#{@browser_type}Browser".constantize
		end

		def find
			browser_klass.new(@sitename, @search_text).found

		rescue StandardError => e
			Rails.logger.error("#{e}, element not found")
			nil
		end

	end
end
