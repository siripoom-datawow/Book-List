# frozen_string_literal: true

class AddAuthtokenToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :auth_token, :string
    add_index :users, :auth_token, unique: true
  end
end
