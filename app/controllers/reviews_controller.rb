# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_book
  before_action :find_review, only: %i[edit update destroy]

  def create
    @review_create = @book.reviews.create!(review_params.merge(user_id: current_user.id))
    redirect_to @book
  end

  def edit; end

  def update
    raise ActiveRecord::RecordNotSaved, @review unless @review.update(review_params)

    flash[:success] = 'Review update completed'
    redirect_to @book
  end

  def destroy
    if @review.destroy
      redirect_to @book
    else
      flash[:alert] = 'Failed to delete the review'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :star)
  end

  def find_book
    @book = Book.find(params[:book_id])
  end

  def find_review
    @review = Review.find(params[:id])
  end
end
