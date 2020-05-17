class ChangeColumnNullOnChats < ActiveRecord::Migration[6.0]
  def change
    change_column_null :chats, :text, false
    change_column_null :chats, :room_id, false
    change_column_null :chats, :user_id, false
  end
end
