Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    devise_for :users, controllers: { sessions: 'sessions' }, skip: [:registrations, :passwords]

    # Teams and team members routes
    resources :teams do
      resources :team_members
    end

    # Sign-up and sign-in routes for API
    post '/signup', to: 'sessions#signup'
    post '/signin', to: 'sessions#signin'
  end
end
