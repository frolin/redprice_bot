class Menu < ApplicationRecord
	has_many :menu_items


	def self.default
		Menu.first
	end

end
