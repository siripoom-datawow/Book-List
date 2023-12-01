class RankingSummation
  include Sidekiq::Job

  def perform
    # Views summation for order ranking
    @previous_rank = Rank.last
    if @previous_rank.present?
      @book_ranks = BookRank.where(rank_id: @previous_rank.id).order(view: :desc)

      @book_ranks.each_with_index do |book_rank,index|
        book_rank.update(order_id: index+1  )
      end
    end

    # Create new rank and bookrank for new day
    @new_rank = Rank.create({date: Date.today })
    @books = Book.all

    @books.each do |book|
      BookRank.create({book_id:book.id, rank_id: @new_rank.id, order_id:0, view: 0})
    end
  end
end
