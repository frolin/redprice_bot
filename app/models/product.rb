# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  name       :string
#  min_price  :integer
#  max_price  :integer
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
class Product < ApplicationRecord
	belongs_to :user
	has_many :stores


	def favorite_store
		stores.find_by('stores.slug = ?', 'ym_f')
	end


	def min_price
		self.favorite_store.min_price
	end


end
