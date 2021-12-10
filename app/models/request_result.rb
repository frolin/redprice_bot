class RequestResult < ApplicationRecord
  belongs_to :request

  store_accessor :data, :final_price


end
