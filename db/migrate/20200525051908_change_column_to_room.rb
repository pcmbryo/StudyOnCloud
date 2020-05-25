class ChangeColumnToRoom < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :rooms, :genre1s
    remove_index :rooms, :genre1_id
    remove_reference :rooms, :genre1
  end
end
