# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :name, presence: true
      t.text :description
      t.datetime :release,  presence: true

      t.timestamps
    end
  end
end
