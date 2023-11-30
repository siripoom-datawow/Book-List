# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_book
  before_action :find_review, only: %i[edit update destroy]

  def create
    @review_create = Review.create!(review_params.merge(user_id: current_user.id, book_id: @book.id))
    redirect_to @book
  end

  def edit; end

  def update
    authorize @review, policy_class: ReviewPolicy
    raise ActiveRecord::RecordNotSaved, @review unless @review.update(review_params)

    flash[:success] = 'Review update completed'
    redirect_to @book
  end

  def destroy
    authorize @review, policy_class: ReviewPolicy

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
