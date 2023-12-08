# frozen_string_literal: true

class AddUserToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :user_id, :integer
    add_index :books, :user_id
    add_foreign_key :books, :users
  end
end
