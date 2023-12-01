# frozen_string_literal: true

class RankingSummation
  include Sidekiq::Job

  def perform
    # Views summation for order ranking
    RankCalculationService.new.perform

    # Create new rank and bookrank for new day
    NewRankBookrankService.new.perform

    puts "Rank summation updated"
  end
end
