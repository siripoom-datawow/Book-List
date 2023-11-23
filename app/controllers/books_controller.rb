# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :find_single_book, only: %i[show edit update destroy]

  def index
    @books = Book.all
  rescue StandardError => e
    Rails.logger.error(e.message)
  end

  def show
    @reviews = Review.where(book_id: params[:id])
  rescue StandardError => e
    Rails.logger.error(e.message)
  end

  def new
    @book = Book.new
  rescue StandardError => e
    Rails.logger.error(e.message)
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      flash[:success] = 'Book create completed'
      redirect_to @book
    else
      flash[:error] = 'Book create fail!'
      render :index
    end
  rescue StandardError => e
    Rails.logger.error(e.message)
  end

  def edit
  rescue StandardError => e
    Rails.logger.error(e.message)
  end

  def update
    if @book.update(book_params)
      flash[:success] = 'Book update completed'
      redirect_to @book
    else
      flash[:error] = 'Updating fail!'
      render :index
    end
  rescue StandardError => e
    Rails.logger.error(e.message)
  end

  def destroy
    begin
      @book.destroy
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
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
