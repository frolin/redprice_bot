module Import
	class Products

		PRODUCT_NAME = 'Наименование '
		MIN_PRICE = 'мин цена (если есть)'

		def initialize(user, url)
			@url = url
			@user = user
		end

		def process
			add = []
			csv = GetData::SpreadSheet.new(url: @url).process
			csv.each do |row|
				@row = row

				binding.pry

				add_product_data
				add_store_data

				product.save!

				add << product
			end

			add
		end

		def add_product_data
			product.name = @row[PRODUCT_NAME]
			product.min_price = @row[MIN_PRICE]
			product.save
		end

		def add_store_data
			clean_columns

			product.stores.new(config: @row.to_h)
		end

		def product
			@product ||= User.first.products.new
		end

		def clean_columns
			[PRODUCT_NAME, MIN_PRICE].each { |col| @row.delete(col) }
		end

	end
end