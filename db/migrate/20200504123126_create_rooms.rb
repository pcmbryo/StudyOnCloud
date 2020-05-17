class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :room_name
      t.text :room_detail
      t.datetime :room_start_datetime
      t.datetime :room_end_datetime
      t.integer :room_capacity
      t.integer :room_end_flg
      t.integer :room_delete_flg
      t.references :user, null: true, foreign_key: true
      t.references :genre1, null: true, foreign_key: true
      t.references :genre2, null: true, foreign_key: true

      t.timestamps
    end
    add_index :rooms, [:user_id, :created_at]
  end
end
