class Notify::Telegram
	include ActionView::Helpers::NumberHelper

	def initialize(products: nil, product: nil, user:)
		@products = products
		@product = product
		@user = user
		@messages = []
	end

	def products_min_price_change
		@products.each do |product|
			min_price_from = product.audits.last.audited_changes.values.flatten.first['min_price']
			min_price_to = product.audits.last.audited_changes.values.flatten.last['min_price']

			message = "🤌 #{product.name}\n"
			message += "Старая цена: #{price_format(min_price_from) } \n"
			message += "Новая цена: #{price_format(min_price_to)}\n\n"

			@messages << message

			if product.sale?
				message += "Распрадажа: Старая цена: #{price_format(product.old_price)} \n Скидка: #{product.discount} % \n\n"
			end
		end

		send_report(@messages)
	end

	def product_min_price_change
		min_price_from = @product.audits.last.audited_changes.values.flatten.first['min_price']
		min_price_to = @product.audits.last.audited_changes.values.flatten.last['min_price']

		message = "🤌 #{@product.name}\n"
		message += "Старая цена: #{price_format(min_price_from) } \n"
		message += "Новая цена: #{price_format(min_price_to)}\n\n"

		send_message(message)
	end

	def create_min_price_to_product
		@products.each do |product|
			message = "- #{product.name}\n"
			message += "Мин. цена: #{price_format(product.min_price)}\n\n"

			if product.sale?
				message += "Старая цена: #{price_format(product.old_price)} Скидка: #{product.discount} % \n\n"
			end

			message += "#{price_format(product.more_price)}\n" if product.more_price.present?

			@messages << message
		end

		if @messages.size > 10
			@messages.each_slice(10) { |msg| send_report(msg) }
		else
			send_report(@messages)
		end
	end

	private

	def send_message(message)
		return unless message.present?

		Telegram.bot.send_message(chat_id: @user.telegram['chat_id'], text: message)
	end

	def send_report(html)
		return unless html.present?

		Telegram.bot.send_message(chat_id: @user.telegram['chat_id'], text: html.join, parse_mode: :html)
	end

	def price_format(price)
		number_to_currency(price || 0, unit: ' ₽', format: "%n%u", delimiter: ' ', precision: 0)
	end

end

