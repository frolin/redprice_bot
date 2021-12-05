class CreateRequestResults < ActiveRecord::Migration[6.1]
  def change
    create_table :request_results do |t|
      t.jsonb :data
      t.string :title
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
