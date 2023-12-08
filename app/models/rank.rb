# frozen_string_literal: true

class Rank < ApplicationRecord
  has_many :bookranks, class: "BookRank", dependent: :destroy
  has_many :books, through: :bookranks
end
