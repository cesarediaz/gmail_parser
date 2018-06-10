class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.string :company
      t.datetime :date
      t.string :description
      t.string :price
      t.string :quantity
      t.string :import

      t.timestamps
    end
  end
end
