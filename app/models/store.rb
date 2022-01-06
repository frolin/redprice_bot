# == Schema Information
#
# Table name: store
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
	CONFIG_PATH = "config/sites_config.yml"

	audited

	belongs_to :product
	delegate :user, to: :product

	has_many :requests

	# has_many :store_requests
	# has_many :requests, through: :store_requests

	# validates :name, uniqueness: true, scope: :user_id
	# store_accessor :config, :ozone, :wildberries, :yandex_market, :sber_market, :aliexpress
	# scope :by_name, ->(name) { joins(:product).where(name: name) }

	def min_price
		requests.last.price
	end

	def self.ya_f_attributes(name='ym_f')
		config = HashWithIndifferentAccess.new(YAML.load_file(CONFIG_PATH))
		config_name = config.fetch(name, nil)
		config_name['attributes'] if config_name
	end

	def config
		config = HashWithIndifferentAccess.new(YAML.load_file(CONFIG_PATH))
		@config ||= config[slug]
	end

	def config_attributes
		config['attributes']
	end

	def last_request
		requests.order(:created_at).last
	end

end
