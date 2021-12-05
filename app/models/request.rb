class Request < ApplicationRecord
	has_one :result, class_name: 'RequestResult'

end
