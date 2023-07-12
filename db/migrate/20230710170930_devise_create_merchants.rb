# frozen_string_literal: true

# Partially autogenerated file
class DeviseCreateMerchants < ActiveRecord::Migration[7.0]
  def change
    create_table :merchants do |t|
      t.string :name, null: false
      t.string :description
      t.string :status, null: false, default: 'active'
      t.boolean :admin, null: false, default: false

      ## Database authenticatable
      t.string :email, null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      t.timestamps null: false
    end

    add_index :merchants, :email, unique: true
    add_index :merchants, :status
  end
end
