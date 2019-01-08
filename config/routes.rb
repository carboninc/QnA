# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'questions#index'
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, except: :index
  end
end
