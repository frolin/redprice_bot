class Request < ApplicationRecord
	has_one :result, class_name: 'RequestResult'

	def max_price
		binding.pry
		result.data.map { |d| d['final_price'].match(/\d+(?:,\d+)?/ )  }
	end

end
