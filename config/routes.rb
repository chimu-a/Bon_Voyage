Rails.application.routes.draw do
  devise_for :customers, controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }

  devise_for :admin, skip: [:registrations] ,controllers: {
  sessions: "admin/sessions"
  }

  scope module: :public do
    root to: 'homes#top'
    get "/about" => "homes#about", as: "about"
    resources :posts
    resources :favorites, only: [:index, :create, :destroy]
    resources :comments, only: [:index, :create, :destroy]
    get "current_customer" => "customers#show"
    patch "current_customer" => "customers#update"
    get "current_customer/edit" => "customers#edit"
    get "current_customer/unsubscribe" => "customers#unsubscribe"
    patch "current_customer/withdraw" => "customers#withdraw"
  end

  namespace :admin do
    root to: 'homes#top'
    resources :posts, only: [:index, :show, :edit, :update, :destroy]
    resources :comments, only: [:index, :show, :destroy]
    resources :customers, only: [:index, :show, :edit, :update]
  end
end
  # namespace :admin do
  #   get 'comments/index'
  #   get 'comments/show'
  #   get 'comments/destroy'
  # end
  # namespace :admin do
  #   get 'posts/index'
  #   get 'posts/show'
  #   get 'posts/edit'
  #   get 'posts/update'
  #   get 'posts/destroy'
  # end
  # namespace :admin do
  #   get 'customers/index'
  #   get 'customers/show'
  #   get 'customers/edit'
  #   get 'customers/update'
  # end
  # namespace :admin do
  #   get 'homes/top'
  # end
  # namespace :public do
  #   get 'comments/index'
  #   get 'comments/create'
  #   get 'comments/destroy'
  # end
  # namespace :public do
  #   get 'favorites/index'
  #   get 'favorites/create'
  #   get 'favorites/destroy'
  # end
  # namespace :public do
  #   get 'posts/index'
  #   get 'posts/new'
  #   get 'posts/create'
  #   get 'posts/show'
  #   get 'posts/edit'
  #   get 'posts/update'
  #   get 'posts/destroy'
  # end
  # namespace :public do
  #   get 'customers/show'
  #   get 'customers/edit'
  #   get 'customers/update'
  #   get 'customers/unsubscribe'
  #   get 'customers/withdraw'
  # end
  # namespace :public do
  #   get 'homes/top'
  #   get 'homes/about'
  # end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html