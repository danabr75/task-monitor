Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  match '/heartbeat',  to: 'tasks#heartbeat', via: [:get, :post]
  match '/failure',    to: 'tasks#failure', via: [:get, :post]

  resources :tasks, only: [:mark_as_active, :mark_as_ignore, :mark_as_unignore] do
    member do
      post :mark_as_active
      post :mark_as_ignore
      post :mark_as_unignore
    end
  end

  # Defines the root path route ("/")
  root "application#homepage"
end
