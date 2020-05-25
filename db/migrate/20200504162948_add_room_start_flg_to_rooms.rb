class AddRoomStartFlgToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :room_start_flg, :integer, default: 0
  end
end
