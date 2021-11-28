class CreateMenuItems < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_items do |t|
      t.text :name
      t.integer :position
      t.string :title
      t.text :body
      t.references :menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
