class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :min_price
      t.integer :max_price
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end
