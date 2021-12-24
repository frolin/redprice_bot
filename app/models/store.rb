# == Schema Information
#
# Table name: stores
#
#  id         :bigint           not null, primary key
#  name       :string
#  url        :string
#  config     :jsonb
#  product_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Store < ApplicationRecord
	belongs_to :product

	has_many :store_requests
	has_many :requests, through: :store_requests

	store_accessor :config, :ozone, :wildberries, :yandex_market, :sber_market, :aliexpress
end
