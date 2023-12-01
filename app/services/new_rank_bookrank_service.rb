# frozen_string_literal: true

class NewRankBookrankService
  def perform
    @new_rank = Rank.create({ date: Date.today })
    @books = Book.all

    @books.each do |book|
      BookRank.create({ book_id: book.id, rank_id: @new_rank.id, order_id: 0, view: 0 })
    end
  end
end
