class AddMoreInfoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_type, :integer, default: 2
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :institution, :string
  end
end
