Rails.application.routes.draw do
  get "dashboard/dash"
  root "pages#index"
  resources :users, only: [:new, :create, :destroy, :index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :menu_items
  resources :orders, only: [:index, :update, :destroy, :show]
  resources :menus do
    post "/activate", :to => "menus#activate", :as => "activate"
  end

  get "signup", to: "users#new", as: "signup"
  get "login", to: "sessions#new", as: "login"
  get "logout", to: "sessions#destroy", as: "logout"
  get "dishes", to: "pages#dishes", as: "dishes"
  get "createuser", to: "users#newuser", as: "admin_new_user"
  post "createuser", to: "users#create_user", as: "admin_create_user"
  post "completeorder", to: "orders#mark_as_complete", as: "complete_order"
  get "dashboard", to: "dashboard#dash", as: "dashboard"

  get "invoice", to: "orders#get_invoice", as: "invoice"
  get "myorders", to: "orders#my_orders", as: "my_orders"

  post "checkout", to: "orders#createorder", as: "checkout"
  post "pages/add_to_cart", to: "pages#add_to_cart", as: "add_to_cart"
  delete "pages/remove_from_cart", to: "pages#remove_from_cart", as: "remove_from_cart"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
