module Import
	class Products < ActiveInteraction::Base
		symbol :type
		integer :user_id

		def execute
			case type
			when :ya_favorites
				Import::Type::YandexMarketFavorites.run(user: user)
			when :csv
				Import::Type::Csv.run(user: user)
			end
		end

		def user
			@user ||= User.find_by(id: user_id)
		end

	end
end