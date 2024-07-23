# frozen_string_literal: true

class UpdateViewService
  def perform
    @views = Rails.cache.read('views')

    if @views
        @today = Rank.last

        @views.each do |key, value|
        @book = BookRank.find_by(book_id: key, rank_id: @today.id)

        if @book.update!(view: @book.view + value)
          Rails.cache.delete('views')
        end
      end
    end
  end
end
