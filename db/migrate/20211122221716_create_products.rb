class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products, force: :cascade do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end
