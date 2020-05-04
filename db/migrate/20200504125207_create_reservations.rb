class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.integer :participation_flg, null: true
      t.references :room, null: false, null: true, foreign_key: true
      t.references :user, null: false, null: true, foreign_key: true

      t.timestamps
    end
  end
end
