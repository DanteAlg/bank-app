class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :number, null: false
      t.references :user
      t.timestamps null: false
    end
  end
end
