# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :release, presence: true

  def all__reviews_comment
    reviews.pluck(:comment).join(', ')
  end

  def get_avg_star
    return 'No review' unless reviews.present?

    star_sum = reviews.reduce(0) { |prev, curr| prev + curr.star }

    star_sum / reviews.length
  end
end
