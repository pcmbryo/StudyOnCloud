class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :room_name, null: false
      t.text :room_detail, null: false
      t.datetime :room_start_datetime, null: false
      t.datetime :room_end_datetime, null: false
      t.integer :room_capacity, null: false
      t.integer :room_start_flg, null: false, default: 0
      t.integer :room_end_flg, null: false, default: 0
      t.integer :room_delete_flg, null: false, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :rooms, [:user_id, :created_at]
  end
end
