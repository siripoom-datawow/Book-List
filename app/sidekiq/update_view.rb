# frozen_string_literal: true

class UpdateView
  include Sidekiq::Job

  def perform
    unless Rank.last
      NewRankBookrankService.new.perform
    end

    UpdateViewService.new.perform
  end
end
