# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ReviewAPI do
  let!(:user)  { create(:user) }

  describe 'Get all reviews' do
    subject { get "/api/v1/book/#{book.id}/review", headers: { 'authorization' => "Bearer: #{user.auth_token}" } }

    let!(:book) { create(:book, user_id: user.id) }
    let!(:review_a) { create(:review, user_id: user.id, book_id: book.id) }
    let!(:review_b) { create(:review, user_id: user.id, book_id: book.id) }

    it 'responds with 200 and retuen reviews for specific book' do
      subject
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq([review_a.as_json, review_b.as_json])
    end

    after do
      Rails.cache.clear
    end
  end

  describe 'Create review' do
    subject do
      post "/api/v1/book/#{book.id}/review", params:, headers: { 'authorization' => "Bearer: #{user.auth_token}" }
    end

    let!(:book) { create(:book, user_id: user.id) }
    let(:params) { { comment: 'comment test', star: 2.0 } }

    it 'response with status 201 and create new review' do
      subject
      expect(Review.last.comment).to eq(params[:comment])
      expect(response.status).to eq(201)
    end

    after do
      Rails.cache.clear
    end
  end

  describe 'Update review' do
    let(:book) { create(:book, user_id: user.id) }
    let(:review) { create(:review, user_id: user.id, book_id: book.id) }

    subject do
      put "/api/v1/book/#{book.id}/review/#{review.id}", params:,
                                                         headers: { 'authorization' => "Bearer: #{user.auth_token}" }
    end

    let(:params) { { comment: 'update comment test', star: 2.0 } }

    it 'response with status 200 with update book' do
      subject
      expect(Review.last.comment).to eq(params[:comment])
      expect(Review.last.comment).not_to eq(review.comment)
      expect(JSON.parse(response.body)['status']).to eq(200)
    end

    after do
      Rails.cache.clear
    end
  end

  describe 'Delete review' do
    let(:book) { create(:book, user_id: user.id) }
    let(:review) { create(:review, user_id: user.id, book_id: book.id) }

    subject do
      delete "/api/v1/book/#{book.id}/review/#{review.id}", headers: { 'authorization' => "Bearer: #{user.auth_token}" }
    end

    it 'response with status 200 and delete review' do
      subject
      expect { Review.find(review.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(JSON.parse(response.body)['status']).to eq(200)
    end

    after do
      Rails.cache.clear
    end
  end
end
