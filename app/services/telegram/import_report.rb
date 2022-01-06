module Telegram

	class ImportReport
		def self.call(user, import_data)
			new = new(user, import_data)
			new.message
		end

		def initialize(user, import_data)
			@import_data = import_data
			@user = user
			@message = message
		end

		def message
			message = []
			message << "Импорт товаров: \n"
			message << "------------------\n"
			message << "добавлено новых: #{@import_data.added.size} \n" if @import_data.added.present?
			message << "найдено и обновлено: #{@import_data.updated.size} \n" if @import_data.updated.present?
			message << "не добавлено: #{@import_data.errors.join("\n")}\n " if @import_data.errors.present?
			message << "------------------\n"
			message << "всего товаров: #{@user.products.size}"

			message.join
		end

	end
end
