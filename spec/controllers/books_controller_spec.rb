# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'GET #index' do
    subject { get :index }
    it 'return all books' do
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    subject { get :show, params: }

    let(:book) { create(:book) }
    let(:params) { { id: book.id } }
    context 'when book existed' do
      it 'return status 200' do
        expect(subject.status).to eq(200)
        expect(book).to eq(Book.find(book.id))
      end
    end

    context 'When Book not found' do
      let(:params) { { id: -1 , format: :json}}
      it 'raise error not found' do
      expect(subject.status).to eq(404)
      expect(JSON.parse(response.body)["error"]).to eq("Data not found")
      end
    end
  end

  describe 'POST #create' do
    subject { post :create, params: }

    context 'when validation success' do
      let(:params) { { book: attributes_for(:book) } }
      it 'creates a new book' do
        expect { subject }.to change(Book, :count).by(1)
        expect(subject).to redirect_to(Book.last)
        expect(subject.status).to eq(302)
      end
    end

    context 'when validation fail' do
      let(:params) { { book: { name: '', description: '', release: '' }, format: :json } }
      it 'raise RecordInvalid  if no book detail' do
        expect(subject.status).to eq(422)
        expect(JSON.parse(response.body)["error"]).to include("Validation failed")
      end
    end
  end

  describe 'PUT #update' do
    subject { put :update, params: { id: book.id, book: book_attr }, format: :json }

    let!(:book) { create(:book) }
    context 'when validation success' do
      let(:book_attr) { attributes_for(:book) }
      it 'Update the book' do
        expect(subject).to redirect_to(Book.find(book.id))
        expect(book.name).to_not eq(Book.find(book.id).name)
      end
    end

    context 'when validation fail' do
      let(:book_attr) { attributes_for(:book, name: '') }
      it 'raise RecordInvalid if no book detail' do
        expect(subject.status).to eq(422)
        expect(JSON.parse(response.body)["error"]).to include("Validation failed")
      end
    end
  end

  describe 'DELETE #deatroy' do
    subject { delete :destroy, params: }
    let!(:book) { create(:book) }
    let(:params) { { id: book.id } }
    it 'Can delete book' do
      expect { subject }.to change(Book, :count).by(-1)
      expect(subject).to redirect_to(root_path)
    end
  end
end
