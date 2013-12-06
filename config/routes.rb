Hrguru::Application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'omniauth_callbacks' },
    skip: [:sessions]
  devise_scope :user do
    get 'sign_in', to: 'welcome#index'
    delete 'sign_out', to: 'devise/sessions#destroy'
  end
  authenticated :user do
    root 'dashboard#index', as: 'dashboard'
  end

  resources :users, only: [:index, :show]
  resources :projects
  resources :memberships, only: [:index]

  root 'welcome#index'
end
