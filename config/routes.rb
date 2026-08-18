# frozen_string_literal: true

Rails.application.routes.draw do
  resources :customers, only: %i[index show]
  resources :orders, only: %i[index show create]
  resources :products, only: %i[index show]

  get "up" => "rails/health#show", as: :rails_health_check
  root "orders#index"
end
