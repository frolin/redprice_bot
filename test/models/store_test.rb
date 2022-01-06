# == Schema Information
#
# Table name: store
#
#  id         :bigint           not null, primary key
#  name       :string
#  url        :string
#  config     :jsonb
#  product_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class StoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
