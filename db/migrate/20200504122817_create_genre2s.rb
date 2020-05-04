class CreateGenre2s < ActiveRecord::Migration[6.0]
  def change
    create_table :genre2s do |t|
      t.string :genre2_name
      t.references :genre1, null: true, foreign_key: true

      t.timestamps
    end
  end
end
