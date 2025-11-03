class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :string, default: "member", null: false
    add_column :users, :name, :string
  end
end
