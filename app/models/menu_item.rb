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
class MenuItem < ApplicationRecord
  belongs_to :menu
end
