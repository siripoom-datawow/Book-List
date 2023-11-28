# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    it 'return all reviews' do
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    subject { post :create, params:, format: :json }

    let!(:user) { create(:user) }
    let(:book) { create(:book, user_id: user.id) }

    before { sign_in user }

    context 'when validation success' do
      let(:params) { { book_id: book.id, review: attributes_for(:review).merge(user_id: user.id) } }

      it 'creates a new review' do
        expect { subject }.to change(Review, :count).by(1)
        expect(subject).to redirect_to(Book.find(book.id))
      end
    end

    context 'when validation fail' do
      let(:params) { { book_id: book.id, review: attributes_for(:review, comment: '') } }

      it 'raise RecordInvalid  if no review detail' do
        expect(subject.status).to eq(422)
        expect(JSON.parse(response.body)['error']).to include('Validation failed')
      end
    end
  end

  describe 'PUT #update' do
    subject { put :update, params: { book_id: book.id, id: review.id, review: review_attr }, format: :json }

    let!(:user) { create(:user) }
    let!(:book) { create(:book, user_id: user.id) }
    let!(:review) { create(:review, user_id: user.id, book_id: book.id) }

    context 'Authorized user' do
      before { sign_in user }

      context 'when validation success' do
        let(:review_attr) { attributes_for(:review).merge(user_id: user.id) }

        it 'Update the review if user authorized' do
          expect(subject).to redirect_to(Book.find(book.id))
          expect(review.comment).to_not eq(Review.find(review.id).comment)
        end
      end

      context 'when validation fail' do
        let(:review_attr) { attributes_for(:review, comment: '').merge(user_id: user.id) }

        it 'response validation fail' do
          expect(subject.status).to eq(422)
        end
      end
    end

    context 'Unathorized user' do
      let!(:other_user) { create(:user) }
      let(:review_attr) { attributes_for(:review).merge(user_id: user.id) }

      before { sign_in other_user }

      it 'Cannot update review' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { book_id: book.id, id: review.id } }

    let!(:user) { create(:user) }
    let(:book) { create(:book, user_id: user.id) }
    let!(:review) { create(:review, book_id: book.id, user_id: user.id) }

    context 'Authorized user' do
      before { sign_in user }

      it 'Can delete review' do
        expect { subject }.to change(Review, :count).by(-1)
        expect(subject).to redirect_to(Book.find(book.id))
      end
    end

    context 'Unathorized user' do
      let!(:other_user) { create(:user) }

      before { sign_in other_user }

      it 'Cannot delete review' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
