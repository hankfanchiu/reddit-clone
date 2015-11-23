Rails.application.routes.draw do
  root to: 'users#new'

  resource :user, only: [:new, :create, :show]

  resource :session, only: [:new, :create, :destroy]

  resources :subs, except: :destroy

  resources :posts, except: :index

  resources :comments, only: [:new, :create]
end
