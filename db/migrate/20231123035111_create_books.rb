# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :name, null: false
      t.text :description
      t.datetime :release, null: false

      t.timestamps
    end
  end
end
