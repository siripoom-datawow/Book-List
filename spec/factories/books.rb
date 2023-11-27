# frozen_string_literal: true

require 'faker'


FactoryBot.define do
  factory :book do
    name { Faker::Name.name}
    description { Faker::Lorem.characters(number:20)}
    release {Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default)}
  end
end
