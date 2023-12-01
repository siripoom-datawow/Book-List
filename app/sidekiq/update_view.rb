class UpdateView
  include Sidekiq::Job

  def perform
    @views = Rails.cache.read("views")

    if @views
      @today = Rank.last

      @views.each do |key,value|
        @book = BookRank.find_by(book_id: key, rank_id: @today.id)

        if @book.update!(view: @book.view + value)
          puts "add #{value} views to book #{@book.book.name}"
          Rails.cache.delete("views")
        else
          puts "========Fail========="
        end
      end
    else
      puts "No update"
    end
  end
end
