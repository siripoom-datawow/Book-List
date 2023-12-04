# frozen_string_literal: true

FactoryBot.define do
  factory :book_rank do
    book { nil }
    rank { nil }
    view { 0 }
    order_id { 0 }
  end
end
