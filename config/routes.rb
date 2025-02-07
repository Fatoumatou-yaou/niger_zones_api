Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "api/v1/statistics#index"

  namespace :api do 
    namespace :v1 do 
      get 'search/regions', to: 'regions#search'
      resources :regions, only: [:index, :show] do 
        resources :departments, only: [:index, :show] do 
          resources :communes, only: [:index, :show] do
            resources :localites, only: [:index, :show]
          end
        end
        get 'statistics', on: :member # Statistiques d'une région
      end
  
      resources :departments, only: [:index, :show] do 
        get 'statistics', on: :member # Statistiques d'un département
        resources :communes, only: [:index, :show] do
          resources :localites, only: [:index, :show]
        end
      end
      resources :communes, only: [:index, :show] do
        get 'statistics', on: :member 
      end
      resources :localites, only: [:index, :show]
  
      get 'statistics', to: 'statistics#index' # Statistiques globales
      get 'search/localites', to: 'localites#search' # Recherche avec filtres
      get 'search/departments', to: 'departments#search' 
      get 'search/communes', to: 'communes#search' 
      get 'departments/:department_id/localites', to: 'localites#by_department' # Localités par département
      get 'regions/:region_id/localites', to: 'localites#by_region' # Localités par région

    end
  end
  
end
