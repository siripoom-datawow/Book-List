# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :comment, presence: true
  validates_numericality_of :star, in: 0..5
end
