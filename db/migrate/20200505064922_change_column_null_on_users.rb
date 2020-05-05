class ChangeColumnNullOnUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :user_name, false
    change_column_null :users, :email, false
  end
end
