# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'GET #index' do
    subject { get :index }
    it 'return all books' do
      expect(response).to be_successful
    end
  end

end
