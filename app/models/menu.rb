# == Schema Information
#
# Table name: menus
#
#  id         :bigint           not null, primary key
#  name       :string
#  position   :integer
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Menu < ApplicationRecord
	has_many :menu_items


	def self.default
		Menu.first
	end

end
