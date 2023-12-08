# frozen_string_literal: true

require 'rails_helper'

describe RankingSummation, type: :job do
  it 'should enque sidekiq' do
    expect { RankingSummation.perform_async }.to enqueue_sidekiq_job
  end
end
