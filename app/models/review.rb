class Review < ApplicationRecord
  belongs_to :book
  validates :comment, presence: true , length: { minimum: 10 }
end
