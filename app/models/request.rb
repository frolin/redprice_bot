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


	# has_many :store_requests
	# has_many :stores, through: :store_requests
	# has_one :store, -> { self.stores.last }
	# validates :price, presence: true

	store_accessor :result, :url, :sale_price, :old_price, :raw_data, :result_errors

	# def max_price
	# 	result.data.map { |d| d['final_price'].match(/\d+(?:,\d+)?/) }
	# end
end
