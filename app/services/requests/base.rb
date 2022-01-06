class Requests::Base

	def initialize(record:, process:)
		@record = record
		@process = process
	end

	def create
		update_request || create_request
	end

	def errors
		add_errors
	end

	private

	def update_request
		if last_request.present?
			if result_changed?
				last_request.update!(result: @process.result, price: @process.result['price'])

				Rails.logger.info("Result changed: #{@process.result} was: #{last_request.result.sort} \n now: #{@process.result.sort}")
				Sentry.capture_message("Result changed: \n was: #{last_request.result.sort} \n now: #{@process.result.sort}", level: :info)
			else
				Rails.logger.info("Result not changed: #{@process.result} was: #{last_request.result.sort} \n now: #{@process.result.sort}")
				Sentry.capture_message("Result not changed: \n was: #{last_request.result.sort} \n now: #{@process.result.sort}", level: :info)
			end
		end
	end

	def create_request
		@record.requests.create!(result: @process.result, price: @process.result[:price])
	end

	def add_errors
		if last_request.present?

			if errors_changed?
				last_request.update!(result_errors: @process.errors.full_messages.join("\n"))
				Sentry.capture_message("Errors changed: #{@process.errors.full_messages.join("\n")}")
			else
				Rails.logger.error("Errors not changed: #{@process.errors.full_messages.join("\n")}")
				Sentry.capture_message("Errors not changed: #{@process.errors.full_messages.join("\n")}")
			end
		end

	end

	def result_changed?
		last_request.result.symbolize_keys != @process.result.symbolize_keys
	end

	def errors_changed?
		last_request.result_errors.symbolize_keys != @process.errors.symbolize_keys
	end

	def last_request
		@last_request ||= @record.last_request
	end

end