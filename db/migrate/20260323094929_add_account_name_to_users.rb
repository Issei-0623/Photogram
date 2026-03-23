class AddAccountNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :account_name, :string
    add_index :users, :account_name, unique: true
  end
end
