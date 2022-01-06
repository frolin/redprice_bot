require "selenium-webdriver"
module Import
	module Type
		class YandexMarketFavorites < ActiveInteraction::Base
			FAVORITES_URL = 'https://market.yandex.ru/my/wishlist'
			object :user

			def execute
				get_products
				check_products
			end

			private

			def get_products
				@products = []

				wait = Selenium::WebDriver::Wait.new(:timeout => 30) # seconds

				articles = wait.until { favorites_page.find_elements(css: "article") }

				articles.each do |article|
					result = {}
					attributes.each do |name, attr|
						result[name] = wait.until { article.find_element(xpath: ".//*[@#{attr}]").text }
					end

					@products << result
				end
			end

			def check_products
				@found = []
				@not_found = []

				@products.each do |product|
					found_product = find_products_by_name(product['name'])

					if found_product.present?
						binding.pry
						@found << found_product
						next if found_product.min_price == product['price']

						found_product.favorite_store.update!(min_price: product['price'], audit_comment: "updated from yandex_market_favorites")
					end


					new_product = user.products.new(name: product['name'])
					store = new_product.stores.new(name: 'YM_F', slug: 'ym_f', url: 'https://market.yandex.ru/my/wishlist')
					store.requests.new(result: product, price: product['price'])
					new_product.save!
				end
			end

			def price_change?

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

		end
	end
end
