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

      def fetch_data(keys,method)
        Rails.cache.fetch(keys) do
        @data = method

        @data.as_json
      end
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

        fetch_data("books/#{page}/#{per_page}/#{books_lastest}",Book.page(page).per(per_page))
      end

      post '/' do
        name = params[:name]
        description = params[:description]
        release = params[:release]

        book = Book.new(params.slice(:name,:description,:release).merge(user:@user))

        if book.save
          { status: 201, message: 'create complete' }
        else
          { status: 500, message: 'create fail', errors: book.errors.full_messages }
        end
      end

      route_param :id do
        desc 'get single book'
      get '/' do
        book_id = params[:id]
        add_views_cache(book_id)

        fetch_data("book/#{book_id}",Book.find(book_id))
      end

      desc 'create book'
      params do
        requires :name, type: String
        optional :description, type: String
        requires :release, type: DateTime
      end

      desc 'update book'
      params do
        requires :name, type: String
        optional :description, type: String
        requires :release, type: DateTime
      end
      put '/' do
        book_id = params[:id]
        name = params[:name]
        description = params[:description]
        release = params[:release]

        book = Book.find(book_id)

        if book.update({ name:, description:, release: })
          { status: 200, message: 'update complete' }
        else
          { status: 500, message: 'update fail', errors: book.errors.full_messages }
        end
      end

      desc 'Delete book'
      delete '/' do
        book_id = params[:id]

        book = Book.find(book_id)

        if book.destroy
          { status: 200, message: 'Delete complete' }
        else
          { status: 500, message: 'Delete fail', errors: book.errors.full_messages }
        end
      end
      end
    end
  end
end
