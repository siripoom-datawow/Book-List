# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RankCalculationService, type: :service do
  describe '#perform' do
    let!(:user) { create(:user) }
    let!(:rank) { create(:rank) }
    let!(:book_a) { create(:book, user_id: user.id) }
    let!(:book_b) { create(:book, user_id: user.id) }
    let!(:book_c) { create(:book, user_id: user.id) }
    let!(:book_d) { create(:book, user_id: user.id) }
    let!(:book_e) { create(:book, user_id: user.id) }
    let!(:book_rank_a) { create(:book_rank, rank:, book: book_a, view: 50) }
    let!(:book_rank_b) { create(:book_rank, rank:, book: book_b, view: 30) }
    let!(:book_rank_c) { create(:book_rank, rank:, book: book_c, view: 80) }
    let!(:book_rank_d) { create(:book_rank, rank:, book: book_d, view: 10) }
    let!(:book_rank_e) { create(:book_rank, rank:, book: book_e, view: 70) }

    it 'summarize correct order' do
      RankCalculationService.new.perform

      expect(book_rank_a.reload.order_id).to eq(3)
      expect(book_rank_b.reload.order_id).to eq(4)
      expect(book_rank_c.reload.order_id).to eq(1)
      expect(book_rank_d.reload.order_id).to eq(5)
      expect(book_rank_e.reload.order_id).to eq(2)
    end
  end
end
