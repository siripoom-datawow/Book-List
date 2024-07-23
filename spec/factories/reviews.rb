# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :review do
    comment { Faker::Lorem.characters(number: 20) }
    star { Faker::Number.between(from: 0.0, to: 5.0) }
    book { create(:book) }
  end
end
