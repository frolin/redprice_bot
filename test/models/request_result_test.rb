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
require "test_helper"

class RequestResultTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
