class ParseStores

	def initialize(user)
		@user = user
	end

	def call
		@user.products.each do |product|
			product.stores.each do |store|
				ParseStore.new(store: store).parse
			end
		end
	end
end