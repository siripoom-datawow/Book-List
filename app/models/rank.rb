# frozen_string_literal: true

class Rank < ApplicationRecord
  has_many :bookranks
  has_many :books, through: :bookranks
end
