Rails.application.routes.draw do
  resource :users, only: [:new, :create, :show]
  resource :sessions, only: [:new, :create, :destroy]
  root to: 'users#new'
end
