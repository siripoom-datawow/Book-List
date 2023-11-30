class TestJob
  include Sidekiq::Job

  def perform
    puts "hello world"
  end
end
