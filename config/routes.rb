# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'questions#index'
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, except: :index do
      post :mark_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
