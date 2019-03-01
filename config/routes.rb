# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: 'questions#index'
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :voteable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: %i[voteable commentable], shallow: true do
    resources :answers, concerns: %i[voteable commentable], except: :index do
      post :mark_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end
end
