class CreateHistory < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.bigint :sender_id, null: false
      t.bigint :reciever_id, null: false
      t.monetize :transfer_balance
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :histories, %i[sender_id reciever_id]
  end
end
