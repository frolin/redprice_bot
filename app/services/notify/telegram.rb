class Notify::Telegram
	include ActionView::Helpers::NumberHelper

	def initialize(products:, user:)
		@products = products
		@user = user
		@messages = []
	end

	def product_min_price_change
		@products.each do |product|
			min_price_from = product.audits.last.audited_changes.values.flatten.first['min_price']
			min_price_to = product.audits.last.audited_changes.values.flatten.last['min_price']

			message = "Изменилась минимальная цена на: #{product.name}\n"
			message += "#{price_format(min_price_from) } => #{price_format(min_price_to)}\n"

			@messages << message

			#
			# if product.sale?
			# 	message += "Распрадажа: Старая цена: #{price_format(product.old_price)} \n"
			# 	message += "Скидкв: #{product.discount} % \n"
			# end
		end

		send_report(@messages)
	end

	def create_min_price_to_product
		@products.each do |product|

			message = "Добавлен продукт: #{product.name}\n"
			message += "Минимальная цена: #{price_format(product.min_price)}\n"

			if product.sale?
				message += "Старая цена: #{price_format(product.old_price)} \n"
				message += "Скидкв: #{product.discount} % \n"
			end

			message += "#{price_format(product.more_price)}\n" if product.more_price.present?

			@messages << message
		end

		send_report(@messages)
	end

	private

	def send_message(message)
		return unless message.present?

		Telegram.bot.send_message(chat_id: @user.telegram['chat_id'], text: message)
	end

	def send_report(html)
		return unless html.present?

		Telegram.bot.send_message(chat_id: @user.telegram['chat_id'], text: html, parse_mode: :html)
	end

	def price_format(price)
		number_to_currency(price || 0, unit: ' ₽', format: "%n%u", delimiter: ' ', precision: 0)
	end

end

