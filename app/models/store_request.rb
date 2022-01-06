# == Schema Information
#
# Table name: store_requests
#
#  id         :bigint           not null, primary key
#  store_id   :bigint           not null
#  request_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class StoreRequest < ApplicationRecord
  belongs_to :store
  belongs_to :request
end
