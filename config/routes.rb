Rails.application.routes.draw do
  root to: 'tests#index'
  get 'tests/index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
