# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewRankBookrankService, type: :service do
  describe '#perform' do
    let!(:user) { create(:user) }
    let!(:book_a) { create(:book, user_id: user.id) }
    let!(:book_b) { create(:book, user_id: user.id) }
    let!(:rank) { create(:rank, date: Date.today - 1) }
    let!(:book_rank_a) { create(:book_rank, rank:, book: book_a, view: 50) }
    let!(:book_rank_b) { create(:book_rank, rank:, book: book_b, view: 30) }

    it 'summarize correct order' do
      puts rank.date
      RankCalculationService.new.perform
      NewRankBookrankService.new.perform

      expect(Rank.last.date).to eq(rank.date + 1.day)
      expect(BookRank.where({ rank: Rank.last }).length).to eq(2)
      expect(BookRank.all.length).to eq(4)
    end
  end
end
