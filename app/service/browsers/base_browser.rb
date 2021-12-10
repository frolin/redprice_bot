require "selenium-webdriver"
module Browsers
	class BaseBrowser
		CONFIG_PATH = "config/sites_config.yml"

		attr_reader :results, :config

		def initialize(sitename, search_text, url)
			@search_text = search_text
			@sitename = sitename
			@config = config.dig(sitename)
			@attributes = config[:attributes]
			@search_query = url || config[:q] + search_text
			@url = url

			@results = []
		end

		def config
			@config ||= HashWithIndifferentAccess.new(YAML.load_file(CONFIG_PATH))
		end

		def browser_klass
			@browser_klass ||= "Browsers::#{config[:browser_type]}Browser".constantize
		end

		def find
			@find ||= browser_klass.new(@sitename, @search_text).process
			request = Request.new.build_result(data: @find)
			request.max_price = @find.select(:final_price).max
			request.save!

		rescue StandardError => e
			Rails.logger.error("browser crashed: #{e}")
			nil
		end

	end
end
