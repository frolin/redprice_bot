# == Schema Information
#
# Table name: requests
#
#  id         :bigint           not null, primary key
#  result     :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  price      :string
#
class Request < ApplicationRecord
	audited

	belongs_to :store
	store_accessor :result, :url, :price, :old_price, :discount, :raw_data, :sale, :result_errors

	# has_many :store_requests
	# has_many :stores, through: :store_requests
	# has_one :store, -> { self.stores.last }
	# validates :price, presence: true

	def sale?
		self.sale
	end

	# def max_price
	# 	result.data.map { |d| d['final_price'].match(/\d+(?:,\d+)?/) }
	# end
end
