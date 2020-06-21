Rails.application.routes.draw do
  devise_for :users

  root 'home#top'
  get 'home/about'

  resources :users,only: [:show,:index,:edit,:update]
  resources :books do
  	resources :book_comments, only: [:create, :destroy]
  	resource :favorites, only: [:create, :destroy]
  end
  
  post 'create/:id' => 'relationships#create', as: 'create' # フォローする
  post 'destroy/:id' => 'relationships#destroy', as: 'destroy' # フォロー外す

  get 'users/:id/follow' => 'users#followed'
  get 'users/:id/follower' => 'users#follower'

end