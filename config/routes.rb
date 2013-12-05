Hrguru::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    get 'sign_in', to: 'welcome#index'
    delete 'sign_out', to: 'devise/sessions#destroy'
  end
  authenticated :user do
    root 'dashboard#index', as: 'dashboard'
  end

  resources :projects

  root 'welcome#index'
end
