# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ReviewAPI do
  let!(:user)  { create(:user) }

  describe 'Get book ranks' do
    subject { get "/api/v1/rank/#{rank.id}/book_rank", headers: { 'authorization' => "Bearer: #{user.auth_token}" } }

    let!(:rank) { create(:rank) }
    let!(:book) { create(:book, user_id: user.id) }
    let!(:book_rank_a) { create(:book_rank, rank_id: rank.id, book_id: book.id, order_id: 2) }
    let!(:book_rank_b) { create(:book_rank, rank_id: rank.id, book_id: book.id, order_id: 1) }
    let!(:book_rank_c) { create(:book_rank, rank_id: rank.id, book_id: book.id, order_id: 4) }
    let!(:book_rank_d) { create(:book_rank, rank_id: rank.id, book_id: book.id, order_id: 3) }

    it 'responds with 200 and retuen all bookranks in asc order' do
      subject
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq([book_rank_b.as_json, book_rank_a.as_json, book_rank_d.as_json,
                                               book_rank_c.as_json])
    end

    after do
      Rails.cache.clear
    end
  end
end
