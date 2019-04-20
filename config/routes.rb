Rails.application.routes.draw do
  get '/users/:user_id', to: 'users#show', as: :user_show
  # post '/signup', to: 'users#create', as: :user_create
  patch '/users/:user_id', to: 'users#update', as: :user_update
  post '/close', to: 'users#destroy', as: :user_destroy
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
