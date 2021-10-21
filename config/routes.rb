Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/version', to: 'application#version'

  namespace :api do
    namespace :v1 do
      resources :countries, only: %i[index show] do
        resources :disease_reports, only: :index
        resources :districts, only: %i[index show] do
          resources :district_reports, only: :index
        end
      end
    end
  end
end
