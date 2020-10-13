Rails.application.routes.draw do
  devise_for :users
  resources :stocks
  
  get 'confirm_stocks', to: 'stocks#confirm'
  delete :stocks, to: 'stocks#destroy_all'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
