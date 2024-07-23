# frozen_string_literal: true

module V1
  class ReviewAPI < Grape::API
    before { authenticate! }

    namespace 'book/:book_id/review' do
      desc 'Get raviews'
      get '/' do
        reviews = Review.where({ book_id: params[:book_id] })

        reviews.as_json
      end

      desc 'create review'
      params do
        requires :comment, type: String
        optional :star, type: Float
      end

      post '/' do
        comment = params[:comment]
        star = params[:star]

        review = Review.new(params.slice(:comment,:star).merge(user:@user, book_id: params[:book_id]))

        if review.save
          { status: 200, message: 'create review complete' }
        else
          { status: 500, message: 'create review fail', errors: review.errors.full_messages }
        end
      end


      route_param :review_id do
        desc 'update review'
        params do
          requires :comment, type: String
          optional :star, type: Float
        end
        put '/' do
          comment = params[:comment]
          star = params[:star]

          review = Review.find(params[:review_id])

          if review.update({ comment:, star: })
            { status: 200, message: 'update review complete' }
          else
            { status: 500, message: 'update review fail', errors: review.errors.full_messages }
          end
        end

        desc 'Delete review'
        delete '/' do
          review = Review.find(params[:review_id])

          if review.destroy
            { status: 200, message: 'Delete review complete' }
          else
            { status: 500, message: 'Delete review fail', errors: review.errors.full_messages }
          end
        end
      end
    end
  end
end
