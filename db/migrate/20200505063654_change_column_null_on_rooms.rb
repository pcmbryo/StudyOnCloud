class ChangeColumnNullOnRooms < ActiveRecord::Migration[6.0]
  def change
    change_column_null :rooms, :room_name, false
    change_column_null :rooms, :room_detail, false
    change_column_null :rooms, :room_start_datetime, false
    change_column_null :rooms, :room_end_datetime, false
    change_column_null :rooms, :room_capacity, false
    change_column_null :rooms, :room_start_flg, false
    change_column_null :rooms, :room_end_flg, false
    change_column_null :rooms, :room_delete_flg, false
    change_column_null :rooms, :user_id, false
    change_column_null :rooms, :genre1_id, false
    change_column_null :rooms, :genre2_id, false
  end
end
