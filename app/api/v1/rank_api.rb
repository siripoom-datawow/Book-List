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

        ranks
      end
    end
  end
end
