# == Schema Information
#
# Table name: users
#
#  id          :bigint           not null, primary key
#  username    :string
#  preferences :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class User < ApplicationRecord
	has_many :products

	FAVORITES_URL = 'https://market.yandex.ru/my/wishlist'

	def favorites_url
		FAVORITES_URL
	end

	def favorites_store
		products.favorite_store
	end

end
