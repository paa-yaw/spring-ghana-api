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

      get 'assign_workers_to_requests/:id/assign_worker/:worker_id', to: 'assign_workers_to_requests#assign_worker', as: :assign_worker
      get 'assign_workers_to_requests/:id', to: 'assign_workers_to_requests#show'
      get 'assign_workers_to_requests/:id/unassign_worker/:worker_id', to: 'assign_workers_to_requests#unassign_worker', as: :unassign_worker 

      resources :workers, only: [:index, :show, :create, :update, :destroy]

      resources :requests, only: [:index]
    end
  end


  end
end
