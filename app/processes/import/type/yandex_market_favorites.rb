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

				@wait = Selenium::WebDriver::Wait.new(:timeout => 1) # seconds

				articles = @wait.until { favorites_page.find_elements(css: "article") }

				raise "not found" if articles.blank?

				articles.each do |article|
					result = {}

					attributes.each do |name, attr|
						begin
							result[name] = find_element_type(data: article, type: name, value: attr)
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
					next if product['name_data'].blank?

					link_data = get_link_params(product['product_link'])
					found_product = Product.find_by(sku: link_data['sku'])
					formatted_price = price_format(product['price_data'])

					if found_product.present?

						if found_product.min_price != formatted_price[:price]
							request = found_product.favorite_store.requests.new(formatted_price)
							request.audit_comment = "updated from yandex_market_favorites"
							request.raw_data = product
							request.save!

							Sentry.capture_message("Product min price change")

							update_min_price(found_product, request)
							Notify::Telegram.new(product: found_product, user: user).product_min_price_change

							next
						end

						Sentry.capture_message("Product price mot changed")

						next
					end

					new_product = user.products.new(name: product['name_data'],
					                                product_link: product['product_link'],
					                                price_link: product['price_link'],
					                                sku: link_data['sku'])
					new_product.link_data = link_data

					store = new_product.stores.new(name: 'YM_F', slug: 'ym_f', url: 'https://market.yandex.ru/my/wishlist')
					request = store.requests.new(formatted_price)
					request.raw_data = product
					new_product.save!

					@new_products << new_product

					Sentry.capture_message("Add new product")

					update_min_price(new_product, request)
				end

				Notify::Telegram.new(products: @new_products, user: user).create_min_price_to_product
			end

			def favorites_page
				@favorites_page ||= Browser.new(FAVORITES_URL).run
			end

			def attributes
				@attributes ||= Store.ya_f_attributes
			end

			# def find_products_by_name(name)
			# 	Product.find_by('name ILIKE ?', "%#{name.strip}%")
			# end

			def find_element_type(data:, type:, value:)
				case type
				when 'name_data'
					element = data.find_element(xpath: ".//*[@#{value}]").attribute("innerHTML")
					element = ActionView::Base.full_sanitizer.sanitize(element)
				when 'product_link', 'price_link'
					element = data.find_element(xpath: ".//*[@#{value}]").find_element(:css, 'a').attribute('href')
				when 'price_data'
					price = data.find_element(xpath: ".//*[@#{value}]")
					prices = price.find_elements(css: 'span')

					if prices.size > 3
						element = ActionView::Base.full_sanitizer.sanitize(prices[0].attribute("innerHTML"))
					else
						element = ActionView::Base.full_sanitizer.sanitize(price.attribute("innerHTML"))
					end

				else
					element = data.find_element(css: value)
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
				price.split("\n").size > 2 || price.split("₽").size > 2
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

			def get_link_params(link)
				uri = URI.parse(link)
				URI.decode_www_form(uri.query).to_h
			end

		end
	end
end
