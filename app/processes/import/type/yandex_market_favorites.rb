require "selenium-webdriver"
module Import
	module Type
		class YandexMarketFavorites < ActiveInteraction::Base
			FAVORITES_URL = 'https://market.yandex.ru/my/wishlist'
			object :user

			def execute
				begin
					get_products
					check_products
				ensure
					favorites_page.quit
				end
			end

			private

			def get_products
				@products = []

				@wait = Selenium::WebDriver::Wait.new(:timeout => 3) # seconds

				articles = @wait.until { favorites_page.find_elements(css: "article") }

				raise "not found" if articles.blank?

				articles.each do |article|
					result = {}
					attributes.each do |name, attr|
						begin
							result[name] = @wait.until { article.find_element(xpath: ".//*[@#{attr}]").text }
						rescue => e
							nil
						end
					end

					@products << result
				end
			end

			def check_products
				@new_products = []
				@product_price_changed = []

				@products.each do |product|
					begin
						found_product = find_products_by_name(product['name'])
					rescue
						binding.pry
					end

					if found_product.present?


						formatted_price = price_format(product['price'])

						if found_product.min_price != formatted_price[:price]
							@product_price_changed << found_product
							request = found_product.favorite_store.requests.new(formatted_price)
							request.audit_comment = "updated from yandex_market_favorites"
							request.raw_data = product
							request.save!

							Sentry.capture_message("Product min price change")

							update_min_price(found_product, request)
							next
						end

						Sentry.capture_message("Product price mot changed")
						next
					end

					formatted_price = price_format(product['price'])

					new_product = user.products.new(name: product['name'])
					store = new_product.stores.new(name: 'YM_F', slug: 'ym_f', url: 'https://market.yandex.ru/my/wishlist')
					request = store.requests.new(formatted_price)
					request.raw_data = product
					new_product.save!

					@new_products << new_product

					Sentry.capture_message("Add new product")

					update_min_price(new_product, request)
				end


				Notify::Telegram.new(products: @product_price_changed, user: user).product_min_price_change
				Notify::Telegram.new(products: @new_products, user: user).create_min_price_to_product
			end

			def favorites_page
				@favorites_page ||= Browser.new(FAVORITES_URL).run
			end

			def attributes
				@attributes ||= Store.ya_f_attributes
			end

			def find_products_by_name(name)
				Product.find_by('name ILIKE ?', "%#{name.strip}%")
			end

			def find_element_type(type, value)
				type = type.split('_').last

				case type
				when 'data'
					element = @wait.until { page.find_element(xpath: "//*[@#{value}]").attribute("innerHTML") }
					element = ActionView::Base.full_sanitizer.sanitize(element)
				else
					element = @wait.until { page.find_element(css: value) }
				end

				element
			end

			def attribute_type(type, element)
				type = type.split('_').last

				case type
				when 'link' then
					element.attribute(:href)
				when 'css' then
					element.text
				else
					element
				end

			rescue
				nil
			end

			def price_format(price)
				if product_with_sale?(price)
					pod = price.split("\n").map { |price| price.gsub(/\D/, '') } # price\n old_price\n discount
					{ price: pod.first.to_i, old_price: pod.second.to_i, discount: pod.third.to_i, sale: true }
				else
					{ price: price.gsub(/\D/, '').to_i, sale: false }
				end
			end

			def product_with_sale?(price)
				price.split("\n").size > 2
			end

			def update_min_price(product, request)
				if product.min_price.blank? || product.min_price != request.price
					if request.sale?
						product.update!(min_price: request.price, sale: request.sale, old_price: request.old_price, discount: request.discount, more_price: request.raw_data['more_prices'])
					else
						product.update!(min_price: request.price, sale: false, more_price: request.raw_data['more_prices'])
					end
				end
			end

		end
	end
end
