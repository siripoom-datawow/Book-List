# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_single_book, only: %i[show edit update destroy]

  def index
    @cached_books = Rails.cache.read("all_books_list")

    if  @cached_books.present?
      @books = Kaminari.paginate_array(@cached_books).page(params[:page]).per(10)
    else
      @books = Book.order(:name).page(params[:page]).per(10)
      Rails.cache.write("all_books_list", Book.all.to_a)
    end

    @total_books = Book.count
  end

  def show
    @cached_reviews = Rails.cache.read("all_reviews_lists")
    @querried_review = @book.reviews

    if  @cached_reviews.present?
      @reviews = Kaminari.paginate_array(@cached_reviews).page(params[:page]).per(10)
    else
      @reviews = @querried_review.page(params[:page]).per(10)
      Rails.cache.write("all_reviews_lists", @querried_review.to_a)
    end

    @total_reviews = @querried_review.count
  end

  def new
    @book = Book.new
  end

  def create
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
end
