# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :find_single_book, only: %i[show edit update destroy]

  def index
    @books = Book.all
  end

  def show
    @reviews = Review.where(book_id: params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    raise ActiveRecord::RecordInvalid, @book unless @book.valid?
    raise ActiveRecord::RecordNotSaved, @book unless @book.save

    flash[:success] = 'Book create completed'
    redirect_to @book
  end

  def edit; end

  def update
    raise ActiveRecord::RecordNotSaved, @book unless @book.update(book_params)

    flash[:success] = 'Book update completed'
    redirect_to @book
  end

  def destroy
    flash[:alert] = 'Failed to delete the book' unless @book.destroy
    redirect_to root_path
  end

  private

  def book_params
    params.require(:book).permit(:name, :description, :release)
  end

  def find_single_book
    @book = Book.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @book.present?
  end
end
