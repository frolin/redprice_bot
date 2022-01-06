module Telegram

	class Greeting

		def self.call(from)
			"Салют, бро #{from['first_name']}"
		end

	end
end
