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
#
class Product < ApplicationRecord
	belongs_to :user
	has_many :stores

	validates_uniqueness_of :name, scope: :user_id
end
