require "api_constraints"

Rails.application.routes.draw do
  devise_for :clients

  namespace :api, defaults: { format: :json },
                  constraints: { subdomain: "api" }, path: "/" do

  scope module: :v1, 
                constraints: ApiConstraints.new(version: 1, default: true) do
                  resources :requests, only: [:show]
                  resources :clients, only: [:show, :create, :update, :destroy] do 
                    resources :requests, only: [:index, :show, :create, :update, :destroy]
                  end
                  resources :sessions, only: [:create, :destroy]
                  resources :workers, only: [:show, :create, :update, :destroy]

    namespace :admin do 
      resources :clients, only: [:index, :show, :create,:update, :destroy] do 
        resources :requests, only: [:show, :create, :update, :destroy] do 
          get 'client_requests', on: :collection
        end
      end 

      resources :workers, only: [:index, :show, :create, :update, :destroy]

      resources :requests, only: [:index]
    end
  end


  end
end
