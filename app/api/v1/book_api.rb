# frozen_string_literal: true

module V1
  class BookAPI < Grape::API
    before { authenticate! }

    helpers do
      def add_views_cache(book_id)
        views_cache = Rails.cache.read('views').dup || {}

        if views_cache.key?(book_id)
          views_cache[book_id] += 1
        else
          views_cache[book_id] = 1
        end

        Rails.cache.write('views', views_cache)
      end
    end

    namespace 'book' do
      desc 'Get all books'
      params do
        optional :page, type: Integer
        optional :per_page, type: Integer
      end

      get '/' do
        page = params[:page] || 1
        per_page = params[:per_page] || 10

        books_lastest = Book.last.id

        Rails.cache.fetch("books/#{page}/#{per_page}/#{books_lastest}") do
          @books = Book.page(page).per(per_page)

          @books.as_json
        end
      end

      desc 'get single book'
      get '/:id' do
        book_id = params[:id]
        add_views_cache(book_id)

        Rails.cache.fetch("book/#{book_id}") do
          @book = Book.find(book_id)

          @book.as_json
        end
      end

      desc 'create book'
      params do
        requires :name, type: String
        optional :description, type: String
        requires :release, type: DateTime
      end

      post '/' do
        name = params[:name]
        description = params[:description]
        release = params[:release]
        user = Rails.cache.read('current_user')

        book = Book.new(name:, description:, release:, user_id: user)

        if book.save!
          { status: 201, message: 'create complete' }
        else
          { status: 500, message: 'create fail', errors: book.errors.full_messages }
        end
      end

      desc 'update book'
      params do
        requires :name, type: String
        optional :description, type: String
        requires :release, type: DateTime
      end

      put '/:id' do
        book_id = params[:id]
        name = params[:name]
        description = params[:description]
        release = params[:release]

        book = Book.find(book_id)

        if book.update!({ name:, description:, release: })
          { status: 200, message: 'update complete' }
        else
          { status: 500, message: 'update fail', errors: book.errors.full_messages }
        end
      end

      desc 'Delete book'
      delete '/:id' do
        book_id = params[:id]

        book = Book.find(book_id)

        if book.destroy!
          { status: 200, message: 'Delete complete' }
        else
          { status: 500, message: 'Delete fail', errors: book.errors.full_messages }
        end
      end
    end
  end
end
