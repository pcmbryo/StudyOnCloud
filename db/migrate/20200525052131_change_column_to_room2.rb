class ChangeColumnToRoom2 < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :rooms, :genre2s
    remove_index :rooms, :genre2_id
    remove_reference :rooms, :genre2
  end
end
