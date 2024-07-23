# frozen_string_literal: true

Rails.application.routes.draw do
  mount ::V1::API => '/api/v1'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  root 'books#index'

  resources :books do
    resources :reviews
  end

  resources :ranks
end
