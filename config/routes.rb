# frozen_string_literal: true
Rails.application.routes.draw do
  root 'books#index'

  resources :books do
    resources :reviews

  end
end
