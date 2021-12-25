class Menu

	def initialize(menu:)
		@menu = menu || default
	end


	def default
		Menu.default
	end

end