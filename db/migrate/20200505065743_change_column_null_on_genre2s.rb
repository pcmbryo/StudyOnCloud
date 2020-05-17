class ChangeColumnNullOnGenre2s < ActiveRecord::Migration[6.0]
  def change
    change_column_null :genre2s, :genre2_name, false
    change_column_null :genre2s, :genre1_id, false
  end
end
