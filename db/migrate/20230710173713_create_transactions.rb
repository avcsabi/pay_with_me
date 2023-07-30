# frozen_string_literal: true

# Table for all types of transactions
class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :type, null: false
      t.string :uuid, null: false
      t.decimal :amount, precision: 14, scale: 2
      t.string :status, null: false
      t.integer :merchant_id, null: false
      t.string :customer_email
      t.string :customer_phone
      t.string :notification_url
      t.references :parent_transaction, polymorphic: true

      t.timestamps
    end

    add_index :transactions, :uuid, unique: true
    add_index :transactions, :status
  end
end
