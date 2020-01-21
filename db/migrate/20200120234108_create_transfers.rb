class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
  	create_table :transfers do |t|
      t.references :source_account, foreign_key: { to_table: :accounts }
      t.references :destination_account, foreign_key: { to_table: :accounts } 
      t.integer :amount_cents
      t.string :currency
      t.timestamps null: false
    end
  end
end
