class Notify::Telegram
	include ActionView::Helpers::NumberHelper

	def initialize(products: nil, product: nil, user:)
		@products = products
		@product = product
		@user = user
		@messages = []
	end

	def products_min_price_change
		binding.pry

		@products.each do |product|
			min_price_from = product.audits.last.audited_changes.values.flatten.first['min_price']
			min_price_to = product.audits.last.audited_changes.values.flatten.last['min_price']

			if prices.size >= 2
				message += "История цен: #{prices.first} -- #{prices.last}"
			end

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

		changed_data = @product.audits.map { |au| au.audited_changes['data'] }.flatten
		prices = changed_data.map { |d| d['min_price'] }.compact.sort

		message = '🤌 '
		message += "<a href=\'#{@product.product_link}\'> #{@product.name}</a> \n\n"
		message += "Старая цена: #{price_format(min_price_from) } \n"
		message += "Новая цена: #{price_format(min_price_to)}\n\n"

		if prices.size >= 2
			message += "История цены: от: #{prices.first} -- до: #{prices.last}"
		end

		send_message(message)
	end

	def create_min_price_to_product
		message = "🛒 Добавлены ноыве товары: \n\n"

		@products.each do |product|
			message = "<a href=\'#{product.product_link}\'> #{product.name}</a> \n"
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

		Telegram.bot.send_message(chat_id: @user.telegram['chat_id'], text: message, parse_mode: :html)
	end

	def send_report(html)
		return unless html.present?

		Telegram.bot.send_message(chat_id: @user.telegram['chat_id'], text: html.join, parse_mode: :html, disable_web_page_preview: true)
	end

	def price_format(price)
		number_to_currency(price || 0, unit: ' ₽', format: "%n%u", delimiter: ' ', precision: 0)
	end

end

