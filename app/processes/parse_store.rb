class ParseStore
	CONFIG_PATH = "config/sites_config.yml"

	def initialize(store:)
		@store = store
		@store_name = store.name

		@url = store.url
		@product = store.product
		@config = config(store.name)
		@attributes = @config[:attributes]
	end

	def parse
		result = store_klass.new(config: @config, store: @store).extract_product_data

		request = Request.create!(result: result[:all_data], price: result[:min_price])
		StoreRequest.create(store_id: @store.id, request_id: request.id).save!
	end

	def store_klass
		"Stores::#{@store_name.classify}".constantize
	end

	def extract_product_data

	end

	def config(name)
		config = HashWithIndifferentAccess.new(YAML.load_file(CONFIG_PATH))
		config[name]
	end

end