# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.string :comment
      t.float :star
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
