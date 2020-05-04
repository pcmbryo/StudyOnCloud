class CreateChats < ActiveRecord::Migration[6.0]
  def change
    create_table :chats do |t|
      t.text :text
      t.references :room, null: true, foreign_key: true

      t.timestamps
    end
    add_index :chats, [:room_id, :created_at]
  end
end
