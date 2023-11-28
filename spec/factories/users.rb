# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    email { "#{Faker::Lorem.characters(number: 10)}@gmail.com" }
    password { Faker::Lorem.characters(number: 10) }
  end
end
