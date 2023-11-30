# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :cached_books
  before_action :find_single_book, only: %i[show edit update destroy]

  def index
    @querried_book = Book.all.to_a

    if  @cached_books.present?
      @books = kaminari_pagination(@cached_books, 10)

    else
      @books = kaminari_pagination(@querried_book, 10)
      Rails.cache.write("all_books_list", @querried_book)
    end

    @total_books = Book.count
  end

  def show
    @cached_reviews = Rails.cache.read("all_reviews_lists")
    @querried_review = @book.reviews

    if @cached_reviews.present?
      @reviews = kaminari_pagination(@cached_reviews.to_a, 10)

    else
      @reviews = kaminari_pagination(@querried_review.to_a, 10)
      Rails.cache.write("all_reviews_lists", @querried_review.to_a)
    end

    @total_reviews = @querried_review.count
  end

  def new
    @book = Book.new
  end

  def create
    if  @cached_books.present?

    else
    end
    @book = Book.create!(book_params.merge(user_id: current_user.id))

    redirect_to @book
  end

  def edit; end

  def update
    authorize @book, policy_class: BookPolicy

    @book.update!(book_params)

    flash[:success] = 'Book update completed'

    redirect_to @book
  end

  def destroy
    authorize @book, policy_class: BookPolicy
    flash[:alert] = 'Failed to delete the book' unless @book.destroy
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

  def cached_books
    @cached_books = Rails.cache.read("all_books_list")
  end

  def kaminari_pagination (array,page)
    Kaminari.paginate_array(array).page(params[:page]).per(page)
  end
end
