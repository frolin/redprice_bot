module Import
	module Type
		class Csv < ActiveInteraction::Base
			integer :user_id
			symbol :type, default: :csv

			PRODUCT_NAME = 'Наименование '
			MIN_PRICE = 'мин цена (если есть)'

			validate do
				errors.add(:username, 'Нет доступа') if user.blank?
			end

			def execute
				@added = []
				@updated = []

				errors.add(:base, 'не праввильная ссылка на файл') unless csv_file.valid?

				csv_file.result.each_with_index do |row, i|
					@row = row
					@i = i + 2

					product = find_or_create_product
					add_stores(product)

					if !product.new_record?
						updated << product
					elsif product.new_record? && product.save
						added << product
					else
						errors << "#{product.name} - #{product.errors.full_messages.join("\n")}"
					end
				end
			end

			private

			def csv_file
				@csv ||= GetData::Spreadsheet.run(url: @url)
			end

			def find_or_create_product
				name = @row[PRODUCT_NAME].strip
				min_price = @row[MIN_PRICE].strip

				find = Product.find_by('name ILIKE ?', "%#{name}%")
				return find if find

				Product.new.tap do |product|
					product.name = name
					product.min_price = min_price
					product.user = user
					product.save!
				end
			end

			def add_stores(product)
				# очищаем что не касается назвния площадок
				stores = @row.to_h.reject { |key, _value| key.in?([PRODUCT_NAME, MIN_PRICE]) }

				stores.each do |name, url|

					store = product.stores.find_or_initialize_by(name: name)

					store.url = url
					store.slug = name.strip.downcase

					store.save!
				end

			end

			def user
				@user ||= User.find_by(id: user_id)
			end
		end

	end
end