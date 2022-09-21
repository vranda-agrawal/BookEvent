class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.text :transaction_id
      t.integer :user_id
      t.string :status
      t.text :token
      t.integer :event_id

      t.timestamps
    end
  end
end
