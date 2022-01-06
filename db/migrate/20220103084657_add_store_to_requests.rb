class AddStoreToRequests < ActiveRecord::Migration[6.1]
  def change
    add_reference :requests, :store, null: false, foreign_key: true
  end
end
