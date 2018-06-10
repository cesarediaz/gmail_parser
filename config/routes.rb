Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  
  get 'welcome/index'
  get 'welcome/refresh_transactions'

  root 'welcome#index'
end
