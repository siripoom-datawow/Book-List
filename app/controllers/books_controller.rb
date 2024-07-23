# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_single_book, only: %i[show edit update destroy]

  def index
    @books = Book.order(:name).page(params[:page]).per(10)
    @total_books = Book.count
  end

  def show
    @reviews = Review.where(book_id: params[:id]).page(params[:page]).per(10)
  end

  def new
    @book = Book.new
  end

  def create
    @user = User.find(current_user.id)
    @book = @user.books.build(book_params)
    @book.save!
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
    @book = Book.find(params[:id])
  end
end
