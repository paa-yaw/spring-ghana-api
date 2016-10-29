require "api_constraints"

Rails.application.routes.draw do
  devise_for :clients
  namespace :api, defaults: { format: :json },
                  constraints: { subdomain: "api" }, path: "/" do

  scope module: :v1, 
                constraints: ApiConstraints.new(version: 1, default: true) do
                  resources :requests, only: [:show, :create, :update, :destroy]
                  resources :clients, only: [:show, :create]
  end

  end
end
