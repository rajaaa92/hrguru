Hrguru::Application.routes.draw do
  devise_for :users,
    controllers: {
      omniauth_callbacks: 'omniauth_callbacks',
      sessions: 'sessions'
    },
    skip: [:sessions]
  devise_scope :user do
    get 'sign_in', to: 'welcome#index', as: :new_user_session
    delete 'sign_out', to: 'sessions#destroy'
  end
  authenticated :user do
    root 'dashboard#index', as: 'dashboard'
  end

  resources :users, only: [:index, :show]
  resources :projects
  resources :memberships, except: [:show]

  root 'welcome#index'
  get '/github_connect', to: 'welcome#github_connect'
end
