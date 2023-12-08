# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    let!(:user) { create(:user) }

    context 'when user signin' do
      before { sign_in user }

      it 'return all books' do
        expect(response).to be_successful
      end
    end

    context 'when user not signin' do
      it 'return status 302' do
        expect(subject.status).to eq(302)
        expect(subject).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    subject { get :show, params: }

    let!(:user) { create(:user) }
    let(:book) { create(:book, user_id: user.id) }
    let(:params) { { id: book.id } }

    context 'when user signin' do
      before { sign_in user }

      context 'when Book existed' do
        it 'return status 200' do
          expect(subject.status).to eq(200)
          expect(assigns(:book)).to eq(book)
        end
      end

      context 'JSON format When Book not found' do
        let(:params) { { id: -1, format: :json } }

        it 'raise error not found' do
          expect(subject.status).to eq(404)
          expect(JSON.parse(response.body)['error']).to eq('Data not found')
        end
      end

      context 'HTML format When Book not found' do
        let(:params) { { id: -1 } }

        it 'flash data not found and redirent to root_path' do
          expect(subject).to redirect_to(root_path)
          expect(flash[:alert]).to eq('No data found')
        end
      end
    end

    context 'when user not signin' do
      it 'return status 302' do
        expect(subject.status).to eq(302)
        expect(subject).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    subject { post :create, params: }

    let!(:user) { create(:user) }
    let(:params) { { book: attributes_for(:book).merge(user_id: user.id) } }

    context 'when user signin' do
      before { sign_in user }

      context 'when validation success' do
        it 'creates a new book' do
          expect { subject }.to change(Book, :count).by(1)
          expect(subject).to redirect_to(Book.last)
          expect(subject.status).to eq(302)
        end
      end

      context 'JSON format when validation fail' do
        let(:params) { { book: { name: '', description: '', release: '' }, format: :json } }

        it 'raise RecordInvalid  if no book detail' do
          expect(subject.status).to eq(422)
          expect(JSON.parse(response.body)['error']).to include('Validation failed')
        end
      end

      context 'HTML format when validation fail' do
        let(:params) { { book: { name: '', description: '', release: '' } } }

        it 'redirect to rooy path and flash error message' do
          expect(subject).to redirect_to(root_path)
          expect(flash[:alert]).to eq("Validation failed: Name can't be blank, Release can't be blank")
        end
      end
    end

    context 'when user not signin' do
      it 'return status 302' do
        expect(subject.status).to eq(302)
        expect(subject).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT #update' do
    subject { put :update, params: { id: book.id, book: book_attr }, format: :json }

    let!(:user) { create(:user) }
    let!(:book) { create(:book, user_id: user.id) }

    context 'Authorized user' do
      before { sign_in user }

      context 'when validation success' do
        let(:book_attr) { attributes_for(:book).merge(user_id: user.id) }

        it 'Update the book if user authorized' do
          expect(subject).to redirect_to(Book.find(book.id))
          expect(book.name).to_not eq(Book.find(book.id).name)
        end
      end

      context 'JSON format when validation fail' do
        let(:book_attr) { attributes_for(:book, name: '').merge(user_id: user.id) }

        it 'response validation fail' do
          expect(subject.status).to eq(422)
          expect(JSON.parse(response.body)['error']).to include('Validation failed')
        end
      end

      context 'HTML format when validation fail' do
        subject { put :update, params: { id: book.id, book: book_attr } }
        let(:book_attr) { attributes_for(:book, name: '').merge(user_id: user.id) }

        it 'response validation fail' do
          expect(subject).to redirect_to(root_path)
          expect(flash[:alert]).to eq("Validation failed: Name can't be blank")
        end
      end
    end

    context 'Unauthorized user' do
      let(:book_attr) { attributes_for(:book).merge(user_id: user.id) }
      let(:other_user) { create(:user) }

      before { sign_in other_user }

      it 'Update fail if user now authorized' do
        expect(subject.status).to eq(403)
      end
    end
  end

  describe 'DELETE #deatroy' do
    subject { delete :destroy, params:, format: :json }

    let(:user) { create(:user) }
    let!(:book) { create(:book, user_id: user.id) }
    let(:params) { { id: book.id } }

    context 'Authorized user' do
      before { sign_in user }

      it 'Can delete book' do
        expect { subject }.to change(Book, :count).by(-1)
        expect(subject).to redirect_to(root_path)
      end
    end

    context 'Unauthorized user' do
      let(:other_user) { create(:user) }

      before { sign_in other_user }

      it 'Update fail if user now authorized' do
        expect(subject.status).to eq(403)
      end
    end
  end
end
