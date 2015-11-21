Rails.application.routes.draw do
  root to: 'users#new'

  resource :users, only: [:new, :create, :show]
  resource :sessions, only: [:new, :create, :destroy]

  resources :subs, except: :destroy
  resources :posts, except: :index
end
