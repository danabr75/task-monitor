Rails.application.routes.draw do
  devise_for :users
  # External API routes
  match '/heartbeat',  to: 'tasks#heartbeat', via: [:post]
  match '/failure',    to: 'tasks#failure', via: [:post]

  # Internal Routes
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
