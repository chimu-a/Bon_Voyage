Rails.application.routes.draw do
  devise_for :customers, controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }

  devise_scope :customer do
    post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  devise_for :admin, skip: [:registrations] ,controllers: {
  sessions: "admin/sessions"
  }

  scope module: :public do
    root to: 'homes#top'
    get "/about" => "homes#about", as: "about"
    get "search" => "searches#search", as: :search
    get "search_tag" => "posts#search_tag"
    resources :posts do
      resource :favorites, only: [:index, :create, :destroy]
    end
    resources :post_items do
      resources :comments, only: [:index, :create, :destroy]
    end
    resources :customers, only: [:show, :edit, :update] do
      member do
        get :favorites
        get :comments
        get :unsubscribe
        patch :withdraw
      end
    end
  end

  namespace :admin do
    root to: 'homes#top'
    resources :posts, only: [:index, :show, :edit, :update, :destroy]
    resources :comments, only: [:index, :show, :destroy]
    resources :customers, only: [:index, :show, :edit, :update] do
      member do
        get :comments
      end
    end
    get "search" => "searches#search"
    get "search_tag" => "posts#search_tag"
  end
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html