# frozen_string_literal: true

class UpdateView
  include Sidekiq::Job

  def perform
    unless Rank.last
      NewRankBookrankService.new.perform
      sleep(5)
    end

    UpdateViewService.new.perform
  end
end
