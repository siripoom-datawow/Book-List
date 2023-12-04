# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_token :auth_token, length: 36

  has_many :reviews, dependent: :destroy
  has_many :books, dependent: :destroy

  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
end
