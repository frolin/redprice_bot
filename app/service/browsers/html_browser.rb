module Browsers
	class HtmlBrowser < BaseBrowser
		def initialize(sitename, search_text)
			super(sitename, search_text)
		end

		def found
			begin
				@found ||= browser.get(@search_query)
				binding.pry
				found_list
			rescue Mechanize::ResponseReadError => e
				@errors = e.force_parse
			end
		end

		private

		def browser
			@browser ||= Mechanize.new
		end

		def found_list

			@found_list ||= @found.search("[class^='#{@site_config[:found_elements_class]}_']")
			# @found_list ||= @found.search("[class^='SearchProductFeed_Preview']")
		end

	end
end
