# frozen_string_literal: true

class RankCalculationService
  def perform
    @previous_rank = Rank.last
    return unless @previous_rank.present?

    @book_ranks = BookRank.where(rank_id: @previous_rank.id).order(view: :desc)

    @book_ranks.each_with_index do |book_rank, index|
      book_rank.update(order_id: index + 1)
    end
  end
end
