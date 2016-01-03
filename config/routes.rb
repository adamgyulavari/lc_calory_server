Rails.application.routes.draw do
  get 'home/index'

  devise_for :users
  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create, :update]
      resources :entries, only: [:index, :create, :update, :destroy]
    end
  end

  root 'home#index'
end
