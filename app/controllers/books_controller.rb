# frozen_string_literal: true

class BooksController < ApplicationController
  include UpdateCacheConcern

  before_action :authenticate_user!
  before_action :cached_books
  before_action :find_all_book
  before_action :find_single_book, only: %i[show edit update destroy]

  def index
    if @cached_books.present?
      @books = kaminari_pagination(@cached_books, 10111)

    else
      @books = kaminari_pagination(@querried_all_books, 10)

      Rails.cache.write('all_books_list', @querried_all_books)
    end

    @total_books = Book.count
  end

  def show
    @cached_reviews = Rails.cache.read("all_reviews_#{params[:id]}")
    @querried_review = @book.reviews

    if @cached_reviews.present?
      @reviews = kaminari_pagination(@cached_reviews, 10)

    else
      @reviews = kaminari_pagination(@querried_review.to_a, 10)
      Rails.cache.write("all_reviews_#{params[:id]}", @querried_review.to_a)
    end

    add_views_cache

    @total_reviews = @querried_review.count
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.create!(book_params.merge(user_id: current_user.id))

    update_cache(find_all_book, 'all_books_list', @querried_all_books) if @cached_books.present?

    redirect_to @book
  end

  def edit; end

  def update
    authorize @book, policy_class: BookPolicy

    @book.update!(book_params)

    update_cache(find_all_book, 'all_books_list', @querried_all_books) if @cached_books.present?

    flash[:success] = 'Book update completed'

    redirect_to @book
  end

  def destroy
    authorize @book, policy_class: BookPolicy

    flash[:alert] = 'Failed to delete the book' unless @book.destroy

    update_cache(find_all_book, 'all_books_list', @querried_all_books) if @cached_books.present?

    redirect_to root_path
  end

  private

  def book_params
    params.require(:book).permit(:name, :description, :release)
  end

  def find_single_book
    @cache_book = Rails.cache.read('book')
    @book = Book.find(params[:id])
  end

  def find_all_book
    @querried_all_books = Book.all.to_a
  end

  def cached_books
    @cached_books = Rails.cache.read('all_books_list')
  end

  def kaminari_pagination(array, page)
    Kaminari.paginate_array(array).page(params[:page]).per(page)
  end

  def add_views_cache
    @views_cache = Rails.cache.read('views').dup || {}

    if @views_cache.key?(@book.id)
      @views_cache[@book.id] += 1
    else
      @views_cache[@book.id] = 1
    end

    Rails.cache.write('views', @views_cache)
  end
end
