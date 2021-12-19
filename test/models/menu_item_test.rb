# == Schema Information
#
# Table name: menu_items
#
#  id         :bigint           not null, primary key
#  name       :text
#  position   :integer
#  title      :string
#  body       :text
#  menu_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class MenuItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
