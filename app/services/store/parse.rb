class Store::Parse < ActiveInteraction::Base
	include ActiveInteraction::Extras::ErrorAndHalt

	integer :store_id

	validate do
		errors.add(:base, 'Not found store') if store.blank?
		errors.add(:base, 'Not valid url.') unless valid_url?(store.url)
	end

	def execute
		begin
			@page = Browser.new(store.url).run
			process = store_klass.run(page: @page, attributes: store.config_attributes, user: store.user)

			if process.valid?
				request = Requests::Base.new(record: store, process: process).create
			else
				request = Requests::Base.new(record: store, process: process).errors

				Sentry.capture_message("Request failed: #{process.errors.full_messages.join("\n")}")
				Rails.logger.error("Request failed: #{process.errors.full_messages.join("\n")}")
				raise 'Request failed: Try to restart job'
			end
		ensure
			@page.quit
		end

		request

		# rescue StandardError => ex
		# 	Sentry.capture_exception(ex)
		# 	Rails.logger.error("Something went wrong: #{ex}, url: #{store.url}")
		#
		# 	raise "Something went wrong: #{ex}, url: #{store.url}"
	end

	private

	def valid_url?(url)
		uri = URI.parse(url)
		uri.is_a?(URI::HTTP) && !uri.host.nil?
	rescue URI::InvalidURIError
		false
	end

	def store_klass
		case store.slug
		when 'ozon' then
			::Store::Type::Ozon
		when 'wb' then
			::Store::Type::Wildberries
		when 'ym' then
			::Store::Type::YandexMarket
		else
			raise 'dont know what type of store.'
		end
	end

	def extract_product_data
	end

	def store
		@store ||= Store.find_by(id: store_id)
	end

end