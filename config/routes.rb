Rails.application.routes.draw do
  root to: 'applications#index'
  devise_for :users
  resources :applications
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
