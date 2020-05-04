class CreateGenre1s < ActiveRecord::Migration[6.0]
  def change
    create_table :genre1s do |t|
      t.string :genre1_name

      t.timestamps
    end
  end
end
