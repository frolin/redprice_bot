# == Schema Information
#
# Table name: request_results
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  title      :string
#  request_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class RequestResult < ApplicationRecord
  belongs_to :request

  store_accessor :data, :final_price


end
