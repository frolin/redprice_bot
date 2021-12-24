module Import
	class Products

		PRODUCT_NAME = 'Наименование '
		MIN_PRICE = 'мин цена (если есть)'

		def initialize(url)
			@url = url
		end

		def process
			csv = GetData::SpreadSheet.new(url: @url).process
			csv.each do |row|

				binding.pry
				product.name = row[PRODUCT_NAME]
				product.min_price = row[MIN_PRICE]
				product.save

				clean_columns(row)
				binding.pry
				product.stores.new(config: row.to_h)

				product.save!
			end
		end

		def product
			@product ||= User.first.products.new
		end

		def clean_columns(row)
			[PRODUCT_NAME, MIN_PRICE].each { |col| row.delete(col) }
		end

	end
end