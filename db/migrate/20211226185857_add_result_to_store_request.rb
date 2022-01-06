class AddResultToStoreRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :store_requests, :result, :jsonb, default: {}
  end
end
