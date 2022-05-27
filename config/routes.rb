Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  match '/heartbeat',  to: 'tasks#heartbeat', via: [:get, :post]

  # Defines the root path route ("/")
  root "application#homepage"
end
