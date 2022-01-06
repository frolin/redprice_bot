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
require "test_helper"

class StoreRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
