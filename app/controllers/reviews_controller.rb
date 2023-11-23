# frozen_string_literal: true

class ReviewsController < ApplicationController
  def create
    begin
      @book = Book.find(params[:book_id])
      @review = @book.reviews.create(review_params)

      redirect_to @book
    rescue => e
       Rails.logger.error(e.message)
    end
  end

  def edit
    begin
      @book = Book.find(params[:book_id])
      @review = Review.find(params[:id])
    rescue => e
       Rails.logger.error(e.message)
    end
  end

  def update
    begin
      @book = Book.find(params[:book_id])
      @review = Review.find(params[:id])
      if @review.update(review_params)
        flash[:success] = "Review update completed"
        redirect_to @book
      else
        flash[:error] = "Review update fail!"
        render :index
      end
    rescue => e
      Rails.logger.error(e.message)
    end
  end

  def destroy
    begin
      @book = Book.find(params[:book_id])
      @review = Review.find(params[:id])
      @review.destroy
    rescue => e
      Rails.logger.error(e.message)
    end
      redirect_to @book
  end

  private

  def review_params
    params.require(:review).permit(:comment, :star)
  end

end
