module Import
	class Products < ActiveInteraction::Base
		string :username
		string :url

		validate do
			errors.add(:username, 'Нет доступа') if user.blank?
			errors.add(:base, 'не праввильная ссылка на файл') unless file.valid?
		end

		PRODUCT_NAME = 'Наименование '
		MIN_PRICE = 'мин цена (если есть)'


		def execute
			csv = file.result


			csv.each do |row|
				@row = row

				add_product_data
				add_store_data

				if product.save
					@results << { product: product, stores: product.stores }
				else
					@errors << product.errors.full_messages.join("\n")
				end
			end
		end

		def file
			@file ||= GetData::Spreadsheet.run(url: @url)
		end

		def add_product_data
			product.name = @row[PRODUCT_NAME]
			product.min_price = @row[MIN_PRICE]
			product.save
		end

		def add_store_data
			clean_columns

			@row.to_h.each { |name, url| product.stores.new(name: name, url: url) }
		end

		def product
			@product ||= user.products.new
		end

		def clean_columns
			[PRODUCT_NAME, MIN_PRICE].each { |col| @row.delete(col) }
		end

		def user
			binding.pry
			@user ||= User.find_by(username: username)
		end
	end
end