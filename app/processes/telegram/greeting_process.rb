module Telegram

	class GreetingProcess

		def self.call(from)
			"Салют, бро #{from['first_name']}"
		end

	end
end
