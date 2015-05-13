SpecialServer::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    resources :users do
      member do
        get :following, :followers
      end
      collection do
        get 'page/:page', action: :index
        get :search
      end
    end
    resources :sessions,        only: [:new, :create, :destroy]
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :microposts,      only: [:create, :destroy] do
      collection do
        get :search
      end
    end
    resources :relationships,   only: [:create, :destroy]

    get '/signup',         to: 'users#new'
    get '/activation/:id', to: 'activations#update', as: :activation
    get '/signin',         to: 'sessions#new'
    delete '/signout',     to: 'sessions#destroy'

    get '/help',    to: 'static_pages#help'
    get '/about',   to: 'static_pages#about'
    get '/contact', to: 'static_pages#contact'

    root to: "static_pages#home", via: :get
  end

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show] do
        member do
          get :following, :followers, :microposts
        end
      end
      resources :authentication, only: :create
      resources :password_resets, only: [:create, :update]
      resources :microposts,     only: [:create, :destroy]
      resources :relationships,  only: [:create, :destroy]
      get  '/feed',   to: 'users#feed'
      post '/signin', to: 'authentication#create'
    end
  end

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
