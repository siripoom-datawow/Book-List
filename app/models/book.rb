class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  validates :name, presence: true
  validates :release, presence: true
end
