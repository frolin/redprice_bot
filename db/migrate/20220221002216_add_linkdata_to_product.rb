class AddLinkdataToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :link_data, :jsonb, default: {}
    add_column :products, :sku, :string, index: true, uniq: true
  end
end
