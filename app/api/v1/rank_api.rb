# frozen_string_literal: true

module V1
  class RankAPI < Grape::API
    before { authenticate! }

    namespace 'rank' do
      desc 'Get rank'
      get '/' do
        ranks = Rank.all

        unless ranks.present?
          NewRankBookrankService.new.perform
          ranks.reload
        end

        ranks.as_json
      end

      desc 'Get single rank'
      get '/:rank_id' do
        rank_id = params[:rank_id]
        rank = Rank.find(rank_id)

        rank.as_json
      end
    end
  end
end
