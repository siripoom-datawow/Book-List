# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :find_book

  def create
    @review = @book.reviews.create(review_params)

    redirect_to @book
  rescue StandardError => e
    Rails.logger.error(e.message)
  end

  def edit
    @review = Review.find(params[:id])
  rescue StandardError => e
    Rails.logger.error(e.message)
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      flash[:success] = 'Review update completed'
      redirect_to @book
    else
      flash[:error] = 'Review update fail!'
      render :index
    end
  rescue StandardError => e
    Rails.logger.error(e.message)
  end

  def destroy
    begin
      @review = Review.find(params[:id])
      @review.destroy
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
    redirect_to @book
  end

  private

  def review_params
    params.require(:review).permit(:comment, :star)
  end

  def find_book
    @book = Book.find(params[:book_id])
  end
end
