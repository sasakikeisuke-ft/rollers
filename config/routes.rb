Rails.application.routes.draw do
  root to: 'applications#index'
  devise_for :users
  resources :applications do
    resources :gemfiles, only: [:index, :new, :create, :edit, :update]
    resources :models
    resources :associations, only: [:new, :create]
    
  end
  
end
