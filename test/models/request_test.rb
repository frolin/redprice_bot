# == Schema Information
#
# Table name: requests
#
#  id         :bigint           not null, primary key
#  result     :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  price      :string
#
require "test_helper"

class RequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
