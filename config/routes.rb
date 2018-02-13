Rails.application.routes.draw do
  resources :questions
  resources :quizzes
  resources :challenges
  resources :users
  resources :sessions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  delete '/logout' => 'sessions#destroy'
  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  root 'application#home'










end
