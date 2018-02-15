Rails.application.routes.draw do
  resources :questions
  resources :users do
    get '/stats' => 'users#stats'
    resources :challenges
    resources :quizzes
    post'/quizzes/:id/result' => 'quizzes#compare'
    get'/quizzes/:id/result' => 'quizzes#result'
  end
  resources :sessions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  delete '/logout' => 'sessions#destroy'
  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  root 'application#home'










end
