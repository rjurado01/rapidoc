Dummy::Application.routes.draw do
  match 'testing', :to => 'testing#redirect', :constraints => { :id => /[A-Z]\d{5}/ }
  match '*tests', :controller => 'testing', :action => 'index'

  resources :users, :only => [ :index, :show, :create ] do
    resources :albums, :only => [ :index, :show, :create, :update, :destroy ] do
      resources :images, :only => [ :index, :show, :create, :update, :destroy ]
    end
  end

  resources :images
end
