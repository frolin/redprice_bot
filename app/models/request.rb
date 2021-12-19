# == Schema Information
#
# Table name: requests
#
#  id         :bigint           not null, primary key
#  result     :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  price      :decimal(8, 2)
#
class Request < ApplicationRecord
	# has_one :result, class_name: 'RequestResult'

	has_many :store_requests
  has_many :stores, through: :store_requests

	validates :price, presence: true

	def max_price
		result.data.map { |d| d['final_price'].match(/\d+(?:,\d+)?/ )  }
	end

end
