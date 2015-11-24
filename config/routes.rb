Rails.application.routes.draw do
  root 'pages#home'

  controller :pages do
    get :home
    get :about
    get :contact
  end

  resource :user, only: [:new, :create, :show, :update]

  resource :session, only: [:new, :create, :destroy]

  resources :subs, except: :destroy

  resources :posts, except: :index do
    post '/upvote', to: 'posts#upvote', on: :member
    post '/downvote', to: 'posts#downvote', on: :member
  end

  resources :comments, only: [:new, :create, :show] do
    post '/upvote', to: 'comments#upvote', on: :member
    post '/downvote', to: 'comments#downvote', on: :member
  end
end
