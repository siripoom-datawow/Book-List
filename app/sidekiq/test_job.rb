class TestJob
  include Sidekiq::Job

  def perform(id)
    puts Book.find(id).name
  end
end
