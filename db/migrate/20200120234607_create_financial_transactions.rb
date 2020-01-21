class CreateFinancialTransactions < ActiveRecord::Migration[6.0]
  def change
  	create_table :financial_transactions do |t|
      t.references :account
      t.references :transfer
      t.string :kind
      t.integer :amount_cents
      t.string :currency
      t.timestamps null: false
    end
  end
end
