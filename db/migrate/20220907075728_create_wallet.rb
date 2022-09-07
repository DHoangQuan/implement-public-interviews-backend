class CreateWallet < ActiveRecord::Migration[6.1]
  def change
    create_table :wallets do |t|
      t.bigint :account_id, null: false
      t.monetize :balance

      t.timestamps
    end

    add_index :wallets, %i[account_id]
  end
end
