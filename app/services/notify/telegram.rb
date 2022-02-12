class Notify::Telegram
	include ActionView::Helpers::NumberHelper

	def initialize(product)
		@product = product
		@user = product.user
	end

	def product_min_price_change
		min_price_from = @product.audits.last.audited_changes.values.flatten.first['min_price']
		min_price_to = @product.audits.last.audited_changes.values.flatten.last['min_price']

		message = "Изменилась минимальная цена на: #{@product.name}\n"
		message += "#{price_format(min_price_from) } => #{price_format(min_price_to)}\n"

		#
		# if @product.sale?
		# 	message += "Распрадажа: Старая цена: #{price_format(@product.old_price)} \n"
		# 	message += "Скидкв: #{@product.discount} % \n"
		# end

		send_message(message)
	end

	def create_min_price_to_product
		message = "Добавлен продукт: #{@product.name}\n"
		message += "Минимальная цена: #{price_format(@product.min_price)}\n"

		if @product.sale?
			message += "Старая цена: #{price_format(@product.old_price)} \n"
			message += "Скидкв: #{@product.discount} % \n"
		end

		message += "#{price_format(@product.more_price)}\n"

		send_message(message)
	end

	private

	def send_message(message)
		Telegram.bot.send_message(chat_id: @user.telegram['chat_id'], text: message)
	end

	def price_format(price)
		number_to_currency(price || 0, unit: ' ₽', format: "%n%u", delimiter: ' ', precision: 0)
	end

end

