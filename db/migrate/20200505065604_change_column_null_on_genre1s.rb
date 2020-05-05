class ChangeColumnNullOnGenre1s < ActiveRecord::Migration[6.0]
  def change
    change_column_null :genre1s, :genre1_name, false
  end
end
