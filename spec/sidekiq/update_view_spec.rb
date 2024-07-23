# frozen_string_literal: true

require 'rails_helper'

describe UpdateView, type: :job do
  it 'should enque sidekiq' do
    expect { UpdateView.perform_async }.to enqueue_sidekiq_job
  end

  it 'should perform in next 1 min' do
    expect { UpdateView.perform_in(1.minute) }.to enqueue_sidekiq_job.in(1.minute)
  end
end
