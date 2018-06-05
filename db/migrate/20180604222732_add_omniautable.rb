class AddOmniautable < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :remember_token, :string
  end

  add_index :users, [:uid, :provider], unique: true
end
