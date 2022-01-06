class Parsing::Stores < ActiveInteraction::Base
	string :username

	validate do
		errors.add(:base, 'not found user') if user.blank?
	end

	def execute
		user.products.each do |product|
			product.stores.each do |store|
				ParseWorker.perform_async(store.id)
			end
		end
	end

	private

	def user
		@user ||= User.find_by(username: username)
	end

end
