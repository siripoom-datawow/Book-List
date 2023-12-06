# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    sequence(:email) { "person#{_1}@example.com" }
    password { Faker::Lorem.characters(number: 10) }
    # encrypted_password { Faker::Lorem.characters(number: 10) }
  end
end
