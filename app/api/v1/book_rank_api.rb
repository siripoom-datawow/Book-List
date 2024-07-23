# frozen_string_literal: true

module V1
  class BookRankAPI < Grape::API
    before { authenticate! }

    namespace 'rank' do
      desc 'Get book rank'
      get '/:rank_id/book_rank' do
        book_rank = BookRank.where({ rank_id: params[:rank_id] })

        raise ActiveRecord::RecordNotFound if book_rank.empty?

        book_rank.order(order_id: :asc).as_json
      end
    end
  end
end
