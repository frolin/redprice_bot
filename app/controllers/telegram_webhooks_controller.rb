class TelegramWebhooksController < Telegram::Bot::UpdatesController

	### AUTH
	class AuthorizationError < StandardError; end

	before_action :authorize!
	rescue_from 'AuthorizationError', with: :deny_access
	###

	include Telegram::Bot::UpdatesController::MessageContext

	use_session!

	def start!(*)
		respond_with :message, text: Telegram::Greeting.call(from), parse_mode: 'HTML'
		inline_keyboard!
	end

	def help!(*)
		respond_with :message, text: t('.content')
	end

	def add_url!(url = nil, *)
		if url
			import_data = Import::Products.run(user: user, url: url)

			if import_data.valid?
				respond_with :message, text: Telegram::ImportReport.call(user, import_data.result)
			else
				respond_with :message, text: "Ошибка: #{import_data.errors}"
			end

		else
			respond_with :message, text: 'кидай ссылку на таблицу:', reply_markup: {
				selective: true,
				force_reply: true
			}

			save_context :add_url!
		end
	end

	def list!(*)
		respond_with :message, text: inline_query(Product, 0)
	end

	def products
		respond_with :message, text: inline_query(Product, 0)
	end

	def memo!(*args)
		if args.any?
			session[:memo] = args.join(' ')
			respond_with :message, text: t('.notice')
		else
			respond_with :message, text: t('.prompt')
			save_context :memo!
		end
	end

	def remind_me!(*)
		to_remind = session.delete(:memo)
		reply = to_remind || t('.nothing')
		respond_with :message, text: reply
	end

	def keyboard!(value = nil, *)
		if value
			respond_with :message, text: t('.selected', value: value)
		else
			save_context :keyboard!
			respond_with :message, text: t('.prompt'), reply_markup: {
				keyboard: [t('.buttons')],
				resize_keyboard: true,
				one_time_keyboard: true,
				selective: true,
			}
		end
	end

	def inline_keyboard!(*)
		respond_with :message, text: t('.prompt'), reply_markup: {
			inline_keyboard: [
				[
					{ text: 'Добавить товар', callback_data: 'add_url' },
					{ text: 'Список товаров', callback_data: 'products_list' },
				],
			# [{ text: t('.repo'), url: 'https://github.com/telegram-bot-rb/telegram-bot' }],
			],
		}
	end

	def callback_query(data)
		case data
		when 'add_url'
			add_url!
		when 'check_price'
			answer_callback_query 'проверяю цены'
			answer_inline_query price_check
		when 'products_list'
			products
		else
			answer_callback_query t('.no_alert')
		end
	end


	def products_list(product)
		# products = Product.all.select(:name, :min_price, :max_price)
		# i = 0
		#
		# products_list = products.map do |product|
		# 	i += 1
		# 	"#{i}: " +
		# 	"#{product.name} \n " +
		# 	"мин.цена: #{product.min_price}, " +
		# 	"макс.цена: #{product.max_price}"
		# end.join("\n")

	end

	def price_check
		respond_with :message, text: CheckPriceProcess.check('aliexpress', 'Lego toys')
	end

	def inline_query(query, _offset)
		query = query # it's just an example, don't use large queries.
		t_description = t('.description')
		t_content = t('.content')
		results = Array.new(5) do |i|
			{
				type: :article,
				title: "#{query}-#{i}",
				id: "#{query}-#{i}",
				description: "#{t_description} #{i}",
				input_message_content: {
					message_text: "#{t_content} #{i}",
				},
			}
		end
		answer_inline_query results
	end

	# As there is no chat id in such requests, we can not respond instantly.
	# So we just save the result_id, and it's available then with `/last_chosen_inline_result`.
	def chosen_inline_result(result_id, _query)
		session[:last_chosen_inline_result] = result_id
	end

	def last_chosen_inline_result!(*)
		result_id = session[:last_chosen_inline_result]
		if result_id
			respond_with :message, text: t('.selected', result_id: result_id)
		else
			respond_with :message, text: t('.prompt')
		end
	end

	def message(message)
		if message['reply_to_message'].present?
			case message.dig('reply_to_message', 'text')

			when 'кидай ссылку на таблицу:'
				add_url!(message['text'])
			end
		end

		respond_with :message, text: t('.content', text: message['text'])
	end

	def action_missing(action, *_args)
		if action_type == :command
			respond_with :message,
			             text: t('telegram_webhooks.action_missing.command', command: action_options[:command])
		end
	end

	private

	def username
		@username ||= from['username']
	end

	def user
		@user ||= User.find_by(username: username)
	end

	def authorize!
		return true if user

		raise AuthorizationError
	end

	def deny_access
		respond_with :message, text: "Кто вы #{username}? Я вас не знаю, обратитесь к адиминстратору"
	end

end
