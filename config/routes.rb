# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'questions#index'
  devise_for :users

  concern :voteable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, concerns: [:voteable], shallow: true do
    resources :answers, concerns: [:voteable], except: :index do
      post :mark_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
