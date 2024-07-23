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
    subject { post :create, params:, format: :json}
    let(:book) { create(:book) }

    context 'when validation success' do
      let(:params) { { book_id: book.id, review: attributes_for(:review) } }
      it 'creates a new revirw' do
        expect { subject }.to change(Review, :count).by(1)
        expect(subject).to redirect_to(Book.find(book.id))
      end
    end

    context 'when validation fail' do
      let(:params) { { book_id: book.id, review: attributes_for(:review, comment: '') } }
      it 'raise RecordInvalid  if no review detail' do
        expect(subject.status).to eq(422)
        expect(JSON.parse(response.body)["error"]).to include("Validation failed")
      end
    end

    describe 'DELETE #destroy' do
      subject { delete :destroy, params: { book_id: book.id, id: review.id } }
      let(:book) { create(:book) }
      let!(:review) { create(:review, book_id: book.id) }
      it 'Can delete review' do
        expect { subject }.to change(Review, :count).by(-1)
        expect(subject).to redirect_to(Book.find(book.id))
      end
    end
  end
end
