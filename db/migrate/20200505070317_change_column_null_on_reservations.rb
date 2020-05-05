class ChangeColumnNullOnReservations < ActiveRecord::Migration[6.0]
  def change
    change_column_null :reservations, :participation_flg, false
    change_column_null :reservations, :room_id, false
    change_column_null :reservations, :user_id, false
  end
end
