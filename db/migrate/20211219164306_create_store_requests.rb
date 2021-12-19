class CreateStoreRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :store_requests do |t|
      t.references :store, null: false, foreign_key: true
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
