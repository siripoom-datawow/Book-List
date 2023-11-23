# frozen_string_literal: true

class BooksController < ApplicationController
  def index
    begin
      @books = Book.all
    rescue => e
       Rails.logger.error(e.message)
    end
  end

  def show
    begin
      @book = Book.find(params[:id])
      @reviews = Review.where(book_id: params[:id])
    rescue => e
       Rails.logger.error(e.message)
    end
  end

  def new
    begin
      @book = Book.new
    rescue => e
      Rails.logger.error(e.message)
    end
  end

  def create
    begin
      @book = Book.new(book_params)
      if @book.save
        flash[:success] = "Book create completed"
        redirect_to @book
      else
        flash[:error] = "Book create fail!"
        render :index
      end
    rescue => e
      Rails.logger.error(e.message)
    end
  end

  def edit
    begin
      @book = Book.find(params[:id])
    rescue => e
      Rails.logger.error(e.message)
    end
  end

  def update
    begin
      @book = Book.find(params[:id])
      if @book.update(book_params)
        flash[:success] = "Book update completed"
        redirect_to @book
      else
        flash[:error] = "Updating fail!"
        render :index
      end
    rescue => e
      Rails.logger.error(e.message)
    end
  end

  def destroy
    begin
      @book = Book.find(params[:id])
      @book.destroy
    rescue => e
      Rails.logger.error(e.message)
    end
      redirect_to root_path
  end

  private
  def book_params
    params.require(:book).permit(:name, :description, :release)
  end

end
