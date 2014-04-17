require 'resque/server'
ParkingApi::Application.routes.draw do
  mount Resque::Server, :at => "/resque"
  defaults format: :json do
    resources :requests
  end

 root 'requests#index'
end
