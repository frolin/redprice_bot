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
	audited

	belongs_to :user
	has_many :stores, dependent: :destroy

	# after_commit :change_message

	store_accessor :data,  :min_price, :sale, :old_price, :discount, :more_price, :product_link, :price_link
	store_accessor :link_data, :modelid, :nid

	def favorite_store
		stores.find_by('stores.slug = ?', 'ym_f')
	end

	def min_price_changes
		favorite_store.requests.last.audits.last.audited_changes['price']
	end

	def sale?
		self.sale
	end

end
