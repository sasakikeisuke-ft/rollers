Rails.application.routes.draw do
  root to: 'applications#index'
  devise_for :users
  resources :applications do
    resources :gemfiles, only: [:index, :new, :create, :edit, :update]
    resources :models do
      resources :columns, only: [:new, :create, :edit, :update] do
        resources :options, only: [:new, :create, :edit, :update]
      end
    end
  end
end
