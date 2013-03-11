Dummy::Application.routes.draw do
  resources :users, :only => [ :index, :show, :create ] do
    resources :albums, :only => [ :index, :show, :create, :update, :destroy ] do
      resources :images, :only => [ :index, :show, :create, :update, :destroy ]
    end
  end

  resources :images
end
