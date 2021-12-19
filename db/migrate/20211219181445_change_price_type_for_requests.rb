class ChangePriceTypeForRequests < ActiveRecord::Migration[6.1]
	def self.up
		change_table :requests do |t|
			t.change :price, :string
		end
	end

	def self.down
		change_table :requests do |t|
			t.change :price, :decimal
		end
	end
end
