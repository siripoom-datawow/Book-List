# frozen_string_literal: true

module V1
  class ReviewAPI < Grape::API
    before { authenticate! }

    namespace 'book/:book_id/review' do
      desc 'Get raviews'
      get '/' do
        reviews = Review.where({book_id: params[:book_id]})
      end

      desc 'create review'
      params do
        requires :comment, type: String
        optional :star, type: Float
      end

      post '/' do
        comment = params[:comment]
        star = params[:star]
        user = Rails.cache.read('current_user')

        review = Review.new(comment:, star:, user_id: user, book_id: params[:book_id])

        if review.save!
          { status: 200, message: 'create review complete' }
        else
          { status: 500, message: 'create review fail', errors: review.errors.full_messages }
        end
      end

      desc 'update review'
      params do
        requires :comment, type: String
        optional :star, type: Float
      end

      put '/:review_id' do
        comment = params[:comment]
        star = params[:star]

        review = Review.find(params[:review_id])

        if review.update!({ comment:, star: })
          { status: 200, message: 'update review complete' }
        else
          { status: 500, message: 'update review fail', errors: review .errors.full_messages }
        end
      end

      desc 'Delete review'
      delete '/:review_id' do

        review = Review.find(params[:review_id])

        if review.destroy!
          { status: 200, message: 'Delete review complete' }
        else
          { status: 500, message: 'Delete review fail', errors: review.errors.full_messages }
        end
      end
    end
  end
end
