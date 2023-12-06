# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::BookAPI do
  let!(:user)  {create(:user)}

  describe 'Get all reviews' do
    subject { get '/api/v1/book' , headers: { 'authorization' => "Bearer: #{user.auth_token}" } }
    let!(:book) {create(:book, user_id: user.id)}

    it 'responds with 200 and return all books' do
      subject
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq([book.as_json])
    end

    after do
      Rails.cache.clear
    end
  end

  describe 'GET single book' do
    subject { get "/api/v1/book/#{book.id}" , headers: { 'authorization' => "Bearer: #{user.auth_token}" } }
    let!(:book) {create(:book, user_id: user.id)}

    it 'responds with 200 and return single book with views update' do
      subject
      expect(response.status).to eq(200)
      expect(Rails.cache.read('views')[book.id.to_s]).to eq(1)
      expect(JSON.parse(response.body)).to eq(book.as_json)
    end

    after do
      Rails.cache.clear
    end
  end

  describe 'create book' do
    subject { post "/api/v1/book", params:  , headers: { 'authorization' => "Bearer: #{user.auth_token}" } }

    let(:params) {{name:"test", description:"soo good book", release: "2023-12-04 23:16:45.279331"}}

    it 'response with status 200 and create new book' do
      subject
      expect(Book.last.name).to eq(params[:name])
      expect(response.status).to eq(201)
    end

    after do
      Rails.cache.clear
    end
  end

  describe 'update book' do
    let(:book) {create(:book, user_id: user.id)}
    subject { put "/api/v1/book/#{book.id}", params:  , headers: { 'authorization' => "Bearer: #{user.auth_token}" } }

    let(:params) {{name:"update name", description:"already update", release: "2023-12-04 23:16:45.279331"}}

    it 'response with status 200 and update book' do
      subject
      expect(Book.last.name).to eq(params[:name])
      expect(JSON.parse(response.body)["status"]).to eq(200)
    end

    after do
      Rails.cache.clear
    end
  end

  describe 'Delete book' do
    let(:book) {create(:book, user_id: user.id)}
    subject { delete "/api/v1/book/#{book.id}" , headers: { 'authorization' => "Bearer: #{user.auth_token}" } }

    it 'response with status 200 and delete book' do
      subject
      expect{Book.find(book.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect(JSON.parse(response.body)["status"]).to eq(200)
    end

    after do
      Rails.cache.clear
    end
  end
end
