require 'rails_helper'

RSpec.describe UpdateViewService, type: :service do
  describe '#perform' do

    let!(:user) {create(:user)}
    let!(:book_a) { create(:book, user_id: user.id) }
    let!(:book_b) { create(:book, user_id: user.id) }
    let!(:book_c) { create(:book, user_id: user.id) }
    let!(:rank) {create(:rank)}
    let!(:book_rank_a) {create(:book_rank, rank: rank, book: book_a)}
    let!(:book_rank_b) {create(:book_rank, rank: rank, book: book_b)}
    let!(:book_rank_c) {create(:book_rank, rank: rank, book: book_c)}

    before do
      Rails.cache.write("views",{book_a.id => 10, book_b.id =>99, book_c.id =>3})
    end

      it 'Update cached view to db' do
        UpdateViewService.new.perform

        expect(book_rank_a.reload.view).to eq(10)
        expect(book_rank_b.reload.view).to eq(99)
        expect(book_rank_c.reload.view).to eq(3)

        expect(Rails.cache.read("views")).to eq(nil)
      end

  end
end
