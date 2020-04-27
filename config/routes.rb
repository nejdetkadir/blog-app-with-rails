Rails.application.routes.draw do
  root 'pages#home'

  resources :articles
  #resources :articles, only: [:show, :index, :new, :create, :edit, :update, :destroy]
end
