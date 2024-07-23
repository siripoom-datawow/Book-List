# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :book do
    name { Faker::Name.name }
    description { Faker::Lorem.characters(number: 20) }
    release { '2023-11-07 17:12:00' }
  end
end
