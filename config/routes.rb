Rails.application.routes.draw do
  root to: 'applications#index'
  devise_for :users
  resources :applications do
    resources :gemfiles, only: [:index, :new, :create, :edit, :update, :show]
    resources :models do
      resources :columns, only: [:new, :create, :edit, :update, :destroy] do
        resources :options, only: [:new, :create, :destroy]
      end
    end
  end
end
