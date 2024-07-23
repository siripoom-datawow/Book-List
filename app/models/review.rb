# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :book

  validates :comment, presence: true
end
